#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
"""Spike S1 + S2 — Thingiverse: real license enum, and which upload path works.

Throwaway. Nothing here ships. It answers two questions the docs contradict
each other on, then deletes everything it made.

  S1  Is there a plain `cc-nc` (CC BY-NC)? The published enum has cc-nc-sa and
      cc-nc-nd but no bare cc-nc. If there isn't one, decision D1 is forced.
  S2  POST /things/{id}/files (upload guide) vs /files/0/uploadFile (OpenAPI
      marks the finalize endpoints deprecated). Also: the real file size cap,
      read out of the presigned policy rather than guessed.

Nothing is ever published. POST /things creates an UNPUBLISHED thing; this
script never calls /publish, and deletes the thing on the way out (including
on failure). Safe to run against your real account.

    export THINGIVERSE_TOKEN=...
    python3 spike_thingiverse.py

Token: https://www.thingiverse.com/apps/create -> create a PRIVATE app (stays
under the 10-user cap, so no moderator review). If the app page shows an app
token, use it. Otherwise do the implicit flow once in a browser:

  https://www.thingiverse.com/login/oauth/authorize?client_id=<ID>&response_type=token

and copy the access_token out of the redirect URL fragment.
"""
import json
import os
import struct
import sys
import urllib.error
import urllib.request

API = "https://api.thingiverse.com"
TOKEN = os.environ.get("THINGIVERSE_TOKEN")

# Values worth probing: the documented enum, plus the bare NC variant we need
# and the 4.0-style spellings in case the enum was modernised.
CANDIDATES = [
    "cc-nc", "cc", "cc-sa", "cc-nd", "cc-nc-sa", "cc-nc-nd",
    "pd0", "gpl", "lgpl", "bsd",
    "cc-by-nc", "cc-by-nc-4.0", "CC BY-NC", "none",
]


def call(method, path, body=None, raw=None, headers=None):
    """Return (status, parsed-or-text). Never raises on HTTP error — the error
    body is the interesting part here."""
    url = path if path.startswith("http") else API + path
    data, hdrs = None, {"Authorization": f"Bearer {TOKEN}"}
    if body is not None:
        data = json.dumps(body).encode()
        hdrs["Content-Type"] = "application/json"
    elif raw is not None:
        data = raw
    hdrs.update(headers or {})
    req = urllib.request.Request(url, data=data, headers=hdrs, method=method)
    try:
        with urllib.request.urlopen(req) as r:
            text = r.read().decode(errors="replace")
            hdr = dict(r.headers)
    except urllib.error.HTTPError as e:
        text, hdr = e.read().decode(errors="replace"), dict(e.headers)
        status = e.code
    else:
        status = r.status if hasattr(r, "status") else 200
    try:
        return status, json.loads(text), hdr
    except json.JSONDecodeError:
        return status, text, hdr


def tiny_stl():
    """Smallest valid binary STL: one triangle. Enough to exercise the upload
    path without caring about geometry."""
    tri = struct.pack("<12fH", 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0)
    return b"\0" * 80 + struct.pack("<I", 1) + tri


def main():
    if not TOKEN:
        sys.exit("set THINGIVERSE_TOKEN first — see the docstring")

    print("== auth check ==")
    status, body, _ = call("GET", "/users/me")
    print(f"GET /users/me -> {status}")
    if status != 200:
        sys.exit(f"auth failed: {body}")
    print(f"  authenticated as: {body.get('name')}\n")

    # --- S1 -----------------------------------------------------------------
    # A deliberately bogus license often makes the API enumerate what it will
    # accept. Cheaper and more truthful than reading stale docs.
    print("== S1: license enum ==")
    status, body, _ = call("POST", "/things", {
        "name": "spike probe (delete me)",
        "license": "__definitely_not_a_license__",
        "category": "3D Printing",
    })
    print(f"invalid-license probe -> {status}")
    print(f"  {json.dumps(body)[:600]}\n")

    # Then find out empirically which values actually take. Each accepted value
    # creates an unpublished thing, which we delete immediately.
    accepted, rejected = [], []
    for lic in CANDIDATES:
        status, body, _ = call("POST", "/things", {
            "name": f"spike license probe {lic} (delete me)",
            "license": lic,
            "category": "3D Printing",
        })
        if status in (200, 201) and isinstance(body, dict) and body.get("id"):
            accepted.append(lic)
            call("DELETE", f"/things/{body['id']}")
        else:
            rejected.append((lic, status, json.dumps(body)[:120]))
        print(f"  {lic:16s} -> {status}")

    print(f"\n  ACCEPTED: {accepted}")
    print(f"  rejected: {[r[0] for r in rejected]}")
    print(f"\n  >>> D1: plain 'cc-nc' accepted? "
          f"{'YES — publish faithfully as CC BY-NC' if 'cc-nc' in accepted else 'NO — D1 decision required'}\n")

    # --- S2 -----------------------------------------------------------------
    print("== S2: upload path + size cap ==")
    lic = "cc-nc" if "cc-nc" in accepted else ("cc-nc-sa" if "cc-nc-sa" in accepted else accepted[0])
    status, thing, _ = call("POST", "/things", {
        "name": "spike upload probe (delete me)",
        "license": lic,
        "category": "3D Printing",
        "description": "Throwaway. Never published. Deleted by the spike script.",
    })
    if status not in (200, 201):
        sys.exit(f"could not create probe thing: {status} {thing}")
    tid = thing["id"]
    print(f"created unpublished thing {tid} (license={lic})")

    try:
        # Path A — the upload guide's documented flow.
        status, prep, _ = call("POST", f"/things/{tid}/files", {"filename": "probe.stl"})
        print(f"\nPath A  POST /things/{tid}/files -> {status}")
        if isinstance(prep, dict) and "fields" in prep:
            fields = prep["fields"]
            print(f"  action: {prep.get('action')}")
            print(f"  google storage: {prep.get('is_google_storage_used')}")
            # The size cap lives inside the base64 policy, not in any doc.
            import base64
            policy = fields.get("policy") or ""
            try:
                decoded = json.loads(base64.b64decode(policy + "=" * (-len(policy) % 4)))
                for cond in decoded.get("conditions", []):
                    if isinstance(cond, list) and "content-length-range" in cond:
                        lo, hi = cond[1], cond[2]
                        print(f"  >>> SIZE CAP: {lo} .. {hi} bytes ({hi / 1048576:.0f} MiB)")
            except Exception as e:
                print(f"  (could not decode policy: {e})")
            print(f"  success_action_redirect: {fields.get('success_action_redirect')}")
        else:
            print(f"  {json.dumps(prep)[:400]}")

        # Path B — the endpoint the OpenAPI spec points at instead.
        status, body, _ = call(
            "POST", "/files/0/uploadFile", raw=tiny_stl(),
            headers={"Content-Type": "application/octet-stream"})
        print(f"\nPath B  POST /files/0/uploadFile -> {status}")
        print(f"  {json.dumps(body)[:300] if isinstance(body, dict) else body[:300]}")

        print("\n  >>> S2: whichever path returned a usable response above is the one to build.")

        # Rate limit headroom, since we just burned a chunk of it.
        _, _, hdr = call("GET", "/users/me")
        rl = {k: v for k, v in hdr.items() if "ratelimit" in k.lower()}
        print(f"\n  rate limit headers: {rl or '(none returned)'}")
    finally:
        status, _, _ = call("DELETE", f"/things/{tid}")
        print(f"\ncleanup: DELETE /things/{tid} -> {status}")

    print("\nDone. Paste this whole output back.")


if __name__ == "__main__":
    main()
