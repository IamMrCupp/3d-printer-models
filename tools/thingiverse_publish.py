#!/usr/bin/env python3
#
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Aaron Cupp
"""Push one model's latest GitHub release to Thingiverse.

    tools/thingiverse_publish.py <model-slug>             # dry run: show what would happen
    tools/thingiverse_publish.py <model-slug> --apply     # create/update the thing, upload files
    tools/thingiverse_publish.py <model-slug> --apply --publish   # ...and take it out of draft

Auth is an App Token from https://www.thingiverse.com/developers (My Apps ->
Create an App -> App Token), read from the THINGIVERSE_TOKEN environment
variable. It is never printed, never written to disk, and never passed on the
command line.

Per model, `<slug>/thingiverse.json` holds what the repo can't derive:

    {"thing_id": 1234567, "category": "Tool Holders & Boxes", "tags": ["gridfinity"]}

`thing_id` is written back on first --apply so later runs UPDATE the same thing
instead of creating a duplicate. Commit it.

What gets uploaded is exactly the GitHub release's assets (STLs + per-part
preview PNGs) for the newest `<slug>/vX.Y.Z` tag, fetched with `gh release
download`, so Thingiverse never carries a mesh CI did not validate. Files whose
MD5 already matches an uploaded file are skipped.

Name comes from the model's row in the main README table; the description is
the model's README with relative links rewritten to GitHub and a footer that
names the release. License comes from the SPDX header in the .scad files, or
CC BY-NC 4.0 when there is none — the repo LICENSE section says every model
directory is NC regardless.

Endpoints (v1, https://api.thingiverse.com, `Authorization: Bearer <token>`):
    POST   /things/                       create   {name, license, category, description, tags}
    PATCH  /things/{id}                   update   same fields
    GET    /things/{id}/files             existing files, with md5
    POST   /files/{id}/uploadFile         multipart field `file` -> {"id": pending}
    POST   /files/{id}/FinalizeFiles      {pending_uploads:[{id,rank}], target_id, target_type:"thing"}
    POST   /things/{id}/publish
The publish payload and the exact license enum are UNVERIFIED until the first
real --apply: every response is printed, and any non-2xx stops the run.
Rate limit is 300 requests per 5 minutes; a run here is well under 30.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import mimetypes
import os
import re
import subprocess
import sys
import tempfile
import uuid
from pathlib import Path
from urllib import error, request

API = "https://api.thingiverse.com"
REPO = "IamMrCupp/3d-printer-models"
RAW = f"https://raw.githubusercontent.com/{REPO}/main"
ROOT = Path(__file__).resolve().parent.parent

# SPDX in the .scad -> Thingiverse license key. The right-hand values are the
# documented v1 API license identifiers; confirm on first use.
LICENSES = {
    "CC-BY-NC-4.0": "cc-nc",
    "CC-BY-4.0": "cc",
    "CC-BY-SA-4.0": "cc-sa",
    "CC-BY-NC-SA-4.0": "cc-nc-sa",
    "MIT": "bsd",   # Thingiverse has no MIT entry; BSD is the closest permissive one
}
DEFAULT_CATEGORY = "Tool Holders & Boxes"


def die(msg: str, code: int = 1) -> None:
    print(f"thingiverse_publish: {msg}", file=sys.stderr)
    sys.exit(code)


# ---- repo-derived metadata --------------------------------------------------

def model_name(slug: str) -> str:
    """The bold title in the model's row of the main README table."""
    for line in (ROOT / "README.md").read_text().splitlines():
        m = re.search(r"\[\*\*(.+?)\*\*\]\(" + re.escape(slug) + r"/\)", line)
        if m:
            return m.group(1)
    die(f"{slug} has no row in the main README table")


def model_license(slug: str) -> str:
    seen = set()
    for scad in (ROOT / slug).glob("*.scad"):
        m = re.search(r"SPDX-License-Identifier:\s*(\S+)", scad.read_text())
        if m:
            seen.add(m.group(1))
    if not seen:
        # The repo LICENSE section makes every <model>/ directory CC BY-NC 4.0
        # whether or not the file says so; the header is optional.
        return LICENSES["CC-BY-NC-4.0"]
    if len(seen) > 1:
        die(f"{slug}: mixed licenses {sorted(seen)} — pick one before publishing")
    spdx = seen.pop()
    if spdx not in LICENSES:
        die(f"{slug}: no Thingiverse mapping for {spdx}")
    return LICENSES[spdx]


def model_description(slug: str, tag: str) -> str:
    """README.md minus the preview image, links made absolute, release footer."""
    text = (ROOT / slug / "README.md").read_text()
    text = re.sub(r"^!\[[^\]]*\]\(preview\.png\)\s*$", "", text, flags=re.M)
    # relative links/images -> raw GitHub
    text = re.sub(r"\]\((?!https?://|#)([^)]+)\)", lambda m: f"]({RAW}/{slug}/{m.group(1)})", text)
    footer = (
        f"\n\n---\n\nParametric OpenSCAD source, render scripts and every revision: "
        f"https://github.com/{REPO}/tree/main/{slug}\n\n"
        f"These files are release **{tag}** — rendered from source and mesh-validated in CI. "
        f"Newer versions, if any: https://github.com/{REPO}/releases?q={slug}\n"
    )
    return text.strip() + footer


def latest_tag(slug: str) -> str:
    out = subprocess.run(
        ["git", "tag", "-l", f"{slug}/v*", "--sort=-v:refname"],
        cwd=ROOT, capture_output=True, text=True, check=True).stdout.split()
    if not out:
        die(f"{slug} has no release tag — release it first")
    return out[0]


def download_release(tag: str, into: Path) -> list[Path]:
    subprocess.run(["gh", "release", "download", tag, "--dir", str(into), "--clobber"],
                   cwd=ROOT, check=True)
    files = sorted(p for p in into.iterdir() if p.suffix.lower() in (".stl", ".png"))
    if not any(p.suffix.lower() == ".stl" for p in files):
        die(f"{tag}: release carries no STL")
    return files


def md5_hex(path: Path) -> str:
    h = hashlib.md5()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


# ---- API ----------------------------------------------------------------------

class Thingiverse:
    def __init__(self, token: str):
        self.token = token

    def _call(self, method: str, path: str, body: bytes | None = None,
              content_type: str | None = None):
        req = request.Request(API + path, data=body, method=method)
        req.add_header("Authorization", f"Bearer {self.token}")
        req.add_header("User-Agent", f"{REPO} thingiverse_publish.py")
        if content_type:
            req.add_header("Content-Type", content_type)
        try:
            with request.urlopen(req, timeout=120) as r:
                raw = r.read()
                return r.status, (json.loads(raw) if raw else None)
        except error.HTTPError as e:
            raw = e.read().decode("utf-8", "replace")
            die(f"{method} {path} -> HTTP {e.code}: {raw[:800]}")

    def json(self, method: str, path: str, payload: dict | None = None):
        body = json.dumps(payload).encode() if payload is not None else None
        return self._call(method, path, body, "application/json" if body else None)

    def upload(self, thing_id: int, path: Path):
        boundary = uuid.uuid4().hex
        ctype = mimetypes.guess_type(path.name)[0] or "application/octet-stream"
        head = (f"--{boundary}\r\nContent-Disposition: form-data; name=\"file\"; "
                f"filename=\"{path.name}\"\r\nContent-Type: {ctype}\r\n\r\n").encode()
        body = head + path.read_bytes() + f"\r\n--{boundary}--\r\n".encode()
        return self._call("POST", f"/files/{thing_id}/uploadFile", body,
                          f"multipart/form-data; boundary={boundary}")


def normalize_md5(value: str | None) -> str | None:
    """The API returns MD5 as hex on old files and base64 on new ones."""
    if not value:
        return None
    if re.fullmatch(r"[0-9a-fA-F]{32}", value):
        return value.lower()
    import base64
    try:
        return base64.b64decode(value).hex()
    except Exception:
        return None


# ---- main -----------------------------------------------------------------------

def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("slug")
    ap.add_argument("--apply", action="store_true", help="talk to Thingiverse (default: dry run)")
    ap.add_argument("--publish", action="store_true", help="after --apply, take the thing out of draft")
    args = ap.parse_args()

    slug = args.slug.rstrip("/")
    if not (ROOT / slug / "README.md").exists():
        die(f"no such model: {slug}")

    meta_path = ROOT / slug / "thingiverse.json"
    meta = json.loads(meta_path.read_text()) if meta_path.exists() else {}
    tag = latest_tag(slug)
    version = tag.split("/v")[-1]
    payload = {
        "name": model_name(slug),
        "license": model_license(slug),
        "category": meta.get("category", DEFAULT_CATEGORY),
        "description": model_description(slug, tag),
        "tags": meta.get("tags", ["gridfinity", "openscad", "electronics bench"]),
    }

    with tempfile.TemporaryDirectory() as td:
        files = download_release(tag, Path(td))
        local = {p.name: (p, md5_hex(p)) for p in files}

        print(f"model     {slug}  ->  \"{payload['name']}\"")
        print(f"release   {tag}")
        print(f"license   {payload['license']}   category  {payload['category']}")
        print(f"tags      {', '.join(payload['tags'])}")
        print(f"thing     {'#' + str(meta['thing_id']) + ' (update)' if meta.get('thing_id') else 'NEW (create)'}")
        print(f"files     {len(files)}:")
        for name, (p, h) in local.items():
            print(f"            {name:36s} {p.stat().st_size:>9,d} B  md5 {h[:8]}")
        print(f"desc      {len(payload['description'])} chars, starts: {payload['description'][:70]!r}")

        if not args.apply:
            print("\ndry run — nothing sent. Add --apply to create/update, --publish to un-draft.")
            return

        token = os.environ.get("THINGIVERSE_TOKEN")
        if not token:
            die("THINGIVERSE_TOKEN is not set. Create an App at https://www.thingiverse.com/developers "
                "and export its App Token; this tool never takes it on the command line.")
        tv = Thingiverse(token)

        if meta.get("thing_id"):
            thing_id = int(meta["thing_id"])
            status, resp = tv.json("PATCH", f"/things/{thing_id}", payload)
            print(f"PATCH /things/{thing_id} -> {status}")
        else:
            status, resp = tv.json("POST", "/things/", payload)
            thing_id = int(resp["id"])
            meta["thing_id"] = thing_id
            meta.setdefault("category", payload["category"])
            meta.setdefault("tags", payload["tags"])
            meta_path.write_text(json.dumps(meta, indent=2) + "\n")
            print(f"POST /things/ -> {status}, thing #{thing_id}; wrote {meta_path.relative_to(ROOT)} — COMMIT IT")
        print(f"          https://www.thingiverse.com/thing:{thing_id}")

        _, existing = tv.json("GET", f"/things/{thing_id}/files")
        have = {f.get("name"): normalize_md5(f.get("md5")) for f in (existing or [])}

        pending = []
        for name, (p, h) in local.items():
            if have.get(name) == h:
                print(f"skip      {name} (same md5 already uploaded)")
                continue
            status, resp = tv.upload(thing_id, p)
            pid = resp.get("id") if isinstance(resp, dict) else None
            if not pid:
                die(f"uploadFile {name} -> {status} with no pending id: {resp}")
            pending.append({"id": pid, "rank": 10 + len(pending)})
            print(f"upload    {name} -> pending {pid}")

        if pending:
            status, resp = tv.json("POST", f"/files/{thing_id}/FinalizeFiles",
                                   {"pending_uploads": pending, "target_id": thing_id, "target_type": "thing"})
            print(f"finalize  {len(pending)} file(s) -> {status}")

        if args.publish:
            status, resp = tv.json("POST", f"/things/{thing_id}/publish", {})
            print(f"publish   -> {status} {json.dumps(resp)[:300] if resp else ''}")
        else:
            print("left as draft — re-run with --publish, or publish from the site.")
        print(f"\ndone: {slug} {version} -> https://www.thingiverse.com/thing:{thing_id}")


if __name__ == "__main__":
    main()
