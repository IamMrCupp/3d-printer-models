#!/usr/bin/env python3
#
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Aaron Cupp
"""Push one model's latest GitHub release to Thingiverse.

    tools/thingiverse_publish.py <model-slug>             # dry run: show what would happen
    tools/thingiverse_publish.py <model-slug> --apply     # create/update the thing, upload files
    tools/thingiverse_publish.py <model-slug> --apply --publish   # ...and take it out of draft
    tools/thingiverse_publish.py --all --skip a,b --apply --publish  # every released model, paced

Auth. The App Token on the developer page is READ-ONLY (the form says so), so
uploads need an OAuth token for the account. One-time:

    export THINGIVERSE_CLIENT_ID=...      # from the app's page on thingiverse.com/developers
    export THINGIVERSE_CLIENT_SECRET=...  # same page; keep it out of the repo
    tools/thingiverse_publish.py --login

--login prints the authorize URL; open it, click Allow, and Thingiverse sends
you to the app's Callback URL with `?code=...` in the address bar. Paste that
code at the prompt. The tool swaps it for an access token and stores it in
~/.config/thingiverse/token (mode 600, outside the repo). Every later run reads
it from there, or from THINGIVERSE_TOKEN if that is set. Nothing secret is ever
printed, committed, or passed on the command line.

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
    GET    /things/{id}/files             existing STLs; `hash` is the base64 MD5
    GET    /things/{id}/images            previews — PNGs are sorted here, and carry no hash
    DELETE /things/{id}/files/{fid}       /  DELETE /things/{id}/images/{iid}
    POST   /files/{id}/uploadFile         multipart field `file` -> {"id": pending}
    POST   /files/{id}/FinalizeFiles      {pending_uploads:[{id,rank}], target_id, target_type:"thing"}
    POST   /things/{id}/publish
Verified 2026-09-23 on wick-solder-spool: license "cc-nc", category names,
POST /publish with an empty body. The first re-run uploaded every file twice
because it read `md5` (the field is `hash`) and never looked at /images —
`--dedupe` exists to clean that up, and now runs after any replacement.
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
import time
import uuid
from pathlib import Path
from urllib import error, request

API = "https://api.thingiverse.com"
AUTHORIZE = "https://www.thingiverse.com/login/oauth/authorize"
TOKEN_URL = "https://www.thingiverse.com/login/oauth/access_token"
TOKEN_FILE = Path.home() / ".config" / "thingiverse" / "token"
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
PACE_S = 60   # seconds between models in --all


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


# ---- duplicates -------------------------------------------------------------------

def dedupe(tv: "Thingiverse", thing_id: int, keep: str, dry: bool = False) -> int:
    """Delete same-named files and previews, keeping one of each.

    Only images at rank < 100 are considered: those are the ranks this tool
    assigns (10, 11, ...). Anything ranked higher was arranged on the site by
    hand and is never touched.

    keep="oldest"  clean up a botched re-upload of identical files — the oldest
                   copy keeps its download count
    keep="newest"  after replacing a changed file — the new one wins
    """
    removed = 0
    pick = min if keep == "oldest" else max
    _, files = tv.json("GET", f"/things/{thing_id}/files")
    _, images = tv.json("GET", f"/things/{thing_id}/images")
    for kind, items, path in (("file", files or [], "files"),
                              ("image", [i for i in (images or []) if (i.get("rank") or 0) < 100], "images")):
        by_name: dict[str, list[dict]] = {}
        for it in items:
            by_name.setdefault(it.get("name"), []).append(it)
        for name, group in sorted(by_name.items()):
            if len(group) < 2:
                continue
            if kind == "file" and keep == "oldest":
                hashes = {normalize_md5(g.get("hash") or g.get("md5")) for g in group}
                if len(hashes) > 1:
                    print(f"keep      {name}: {len(group)} copies differ in content — not touching")
                    continue
            winner = pick(group, key=lambda g: int(g["id"]))
            for g in group:
                if g is winner:
                    continue
                print(f"{'would delete' if dry else 'delete'}  {kind} {name} #{g['id']} (keeping #{winner['id']})")
                if not dry:
                    tv.json("DELETE", f"/things/{thing_id}/{path}/{g['id']}")
                removed += 1
    return removed


# ---- login ----------------------------------------------------------------------

def login() -> None:
    cid = os.environ.get("THINGIVERSE_CLIENT_ID")
    secret = os.environ.get("THINGIVERSE_CLIENT_SECRET")
    if not (cid and secret):
        die("set THINGIVERSE_CLIENT_ID and THINGIVERSE_CLIENT_SECRET from the app's developer page first")
    print("1. Open this in a browser where you are signed in to Thingiverse, and click Allow:\n")
    print(f"   {AUTHORIZE}?client_id={cid}&response_type=code\n")
    print("2. You land on the app's Callback URL with ?code=... in the address bar.")
    code = input("   Paste the code here: ").strip()
    if not code:
        die("no code given")
    from urllib.parse import urlencode, parse_qs
    body = urlencode({"client_id": cid, "client_secret": secret, "code": code}).encode()
    req = request.Request(TOKEN_URL, data=body, method="POST")
    req.add_header("User-Agent", f"{REPO} thingiverse_publish.py")
    try:
        with request.urlopen(req, timeout=60) as r:
            raw = r.read().decode()
    except error.HTTPError as e:
        die(f"token exchange -> HTTP {e.code}: {e.read().decode('utf-8', 'replace')[:400]}")
    # Thingiverse answers this endpoint as a query string, not JSON
    token = parse_qs(raw).get("access_token", [None])[0]
    if not token:
        try:
            token = json.loads(raw).get("access_token")
        except Exception:
            token = None
    if not token:
        die(f"no access_token in the reply (first 200 chars, secrets redacted): {raw[:200]!r}")
    TOKEN_FILE.parent.mkdir(parents=True, exist_ok=True)
    TOKEN_FILE.write_text(token + "\n")
    TOKEN_FILE.chmod(0o600)
    # prove it is a user token, not the read-only app token
    tv = Thingiverse(token)
    status, me = tv.json("GET", "/users/me")
    print(f"\nsigned in as {me.get('name') if isinstance(me, dict) else '?'}; token saved to {TOKEN_FILE}")


def load_token() -> str:
    token = os.environ.get("THINGIVERSE_TOKEN")
    if not token and TOKEN_FILE.exists():
        token = TOKEN_FILE.read_text().strip()
    if not token:
        die("no token: run `tools/thingiverse_publish.py --login` once (or set THINGIVERSE_TOKEN)")
    return token


# ---- main -----------------------------------------------------------------------

def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("slug", nargs="?")
    ap.add_argument("--login", action="store_true", help="one-time OAuth: store an access token for this account")
    ap.add_argument("--apply", action="store_true", help="talk to Thingiverse (default: dry run)")
    ap.add_argument("--publish", action="store_true", help="after --apply, take the thing out of draft")
    ap.add_argument("--all", action="store_true", help="every released model, one at a time, paced for the rate limit")
    ap.add_argument("--skip", help="with --all: comma-separated model slugs to leave out")
    ap.add_argument("--dedupe", action="store_true",
                    help="remove identical duplicate files/previews, keeping the oldest (dry run unless --apply)")
    args = ap.parse_args()

    if args.login:
        login()
        return
    if args.all:
        if args.dedupe:
            ap.error("--dedupe works on one model at a time")
        skip = {x.strip().rstrip("/") for x in (args.skip or "").split(",") if x.strip()}
        slugs = [d.name for d in sorted(ROOT.iterdir())
                 if (d / "README.md").exists() and d.name not in skip
                 and subprocess.run(["git", "tag", "-l", f"{d.name}/v*"], cwd=ROOT,
                                    capture_output=True, text=True).stdout.strip()]
        print(f"{len(slugs)} released model(s); skipping {sorted(skip) or 'none'}\n")
        for i, slug in enumerate(slugs):
            print(f"==== [{i+1}/{len(slugs)}] {slug}")
            publish_one(slug, args)
            # 300 requests / 5 min. The biggest model is ~30 requests; a minute
            # between models keeps any 5-minute window far under the limit.
            if args.apply and i + 1 < len(slugs):
                time.sleep(PACE_S)
            print()
        return
    if not args.slug:
        ap.error("model slug required (or --all, or --login)")
    publish_one(args.slug.rstrip("/"), args)


def publish_one(slug: str, args) -> None:
    if not (ROOT / slug / "README.md").exists():
        die(f"no such model: {slug}")

    meta_path = ROOT / slug / "thingiverse.json"
    meta = json.loads(meta_path.read_text()) if meta_path.exists() else {}

    if args.dedupe:
        if not meta.get("thing_id"):
            die(f"{slug} has no thing_id yet")
        n = dedupe(Thingiverse(load_token()), int(meta["thing_id"]), keep="oldest", dry=not args.apply)
        print(f"{n} duplicate(s) {'removed' if args.apply else 'found — re-run with --apply to remove'}")
        return
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

        tv = Thingiverse(load_token())

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
        _, images = tv.json("GET", f"/things/{thing_id}/images")
        # STLs land in /files with a `hash` (base64 MD5). PNGs are sorted into
        # /images, which carry no hash at all — so previews are re-sent only when
        # the release changes, and the stored release tag is what tells us that.
        have = {f.get("name"): normalize_md5(f.get("hash") or f.get("md5")) for f in (existing or [])}
        have_img = {i.get("name") for i in (images or [])}
        same_release = meta.get("release") == tag

        pending = []
        for name, (p, h) in local.items():
            if p.suffix.lower() == ".png":
                if same_release and name in have_img:
                    print(f"skip      {name} (release unchanged, preview already on the thing)")
                    continue
            elif have.get(name) == h:
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
            # a changed STL or a new release's preview replaces the old one of the same name
            dedupe(tv, thing_id, keep="newest")
        meta["release"] = tag
        meta_path.write_text(json.dumps(meta, indent=2) + "\n")

        if args.publish:
            status, resp = tv.json("POST", f"/things/{thing_id}/publish", {})
            print(f"publish   -> {status} {json.dumps(resp)[:300] if resp else ''}")
        else:
            _, cur = tv.json("GET", f"/things/{thing_id}")
            if isinstance(cur, dict) and cur.get("is_published"):
                print("already public — updated in place.")
            else:
                print("left as draft — re-run with --publish, or publish from the site.")
        print(f"\ndone: {slug} {version} -> https://www.thingiverse.com/thing:{thing_id}")


if __name__ == "__main__":
    main()
