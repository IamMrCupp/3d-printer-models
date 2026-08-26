#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
"""Spike S3 — Cults3D: exact licenseCode strings and createCreation's real signature.

Throwaway. Read-only: this introspects the schema and reads your own account.
It never creates, updates or deletes a design.

Their licenses page confirms CC BY-NC is offered on FREE designs. What it
doesn't give us is the machine value — the official example only shows
`cults_cu` (a paid license), so the CC codes are unknown. This gets them from
the schema instead of guessing.

Also confirms whether `tagNames` and `madeWithAi` are really accepted
arguments, which so far only appear in community notes of uncertain quality.

    export CULTS3D_USER=your-username
    export CULTS3D_KEY=your-api-key
    python3 spike_cults3d.py

Key: https://cults3d.com/en/api/keys — self-serve, no approval. A read-only
key is enough for this script.
"""
import json
import os
import sys
import urllib.error
import urllib.request
from base64 import b64encode

ENDPOINT = "https://cults3d.com/graphql"
USER = os.environ.get("CULTS3D_USER")
KEY = os.environ.get("CULTS3D_KEY")


def gql(query):
    auth = b64encode(f"{USER}:{KEY}".encode()).decode()
    req = urllib.request.Request(
        ENDPOINT,
        data=json.dumps({"query": query}).encode(),
        headers={"Content-Type": "application/json", "Authorization": f"Basic {auth}"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req) as r:
            return json.loads(r.read().decode())
    except urllib.error.HTTPError as e:
        return {"httpError": e.code, "body": e.read().decode(errors="replace")[:800]}


def unwrap(t):
    """GraphQL type refs nest through NON_NULL / LIST wrappers."""
    while t and not t.get("name"):
        t = t.get("ofType")
    return (t or {}).get("name", "?")


def main():
    if not (USER and KEY):
        sys.exit("set CULTS3D_USER and CULTS3D_KEY first — see the docstring")

    print("== auth check ==")
    r = gql("{ me { nick } }")
    print(json.dumps(r)[:300])
    if "httpError" in r:
        sys.exit("auth failed — check the username/key pair")
    print()

    # --- createCreation's real argument list --------------------------------
    print("== createCreation signature ==")
    r = gql("""
    { __type(name: "Mutation") { fields {
        name
        args { name description type { kind name ofType { kind name ofType { kind name } } } }
    } } }""")
    fields = (r.get("data", {}).get("__type") or {}).get("fields") or []
    if not fields:
        print("  introspection appears disabled or the mutation type is named differently")
        print(f"  {json.dumps(r)[:500]}\n")
    else:
        print(f"  mutations exposed: {sorted(f['name'] for f in fields)}\n")
        for f in fields:
            if f["name"] == "createCreation":
                print("  createCreation args:")
                for a in f["args"]:
                    print(f"    {a['name']:22s} {unwrap(a['type'])}")
                names = {a["name"] for a in f["args"]}
                print(f"\n  >>> tagNames accepted?   {'YES' if 'tagNames' in names else 'NO'}")
                print(f"  >>> madeWithAi accepted? {'YES' if 'madeWithAi' in names else 'NO'}")
                print(f"  >>> licenseCode type:    "
                      f"{next((unwrap(a['type']) for a in f['args'] if a['name'] == 'licenseCode'), 'absent')}")
                print()

    # --- the license codes themselves ---------------------------------------
    print("== license codes ==")
    found = False
    for tname in ("LicenseCode", "License", "CreationLicense", "LicenseEnum"):
        r = gql(f'{{ __type(name: "{tname}") {{ kind name enumValues {{ name description }} '
                f'fields {{ name }} }} }}')
        t = (r.get("data") or {}).get("__type")
        if t:
            found = True
            print(f"  type {tname}: kind={t.get('kind')}")
            for v in (t.get("enumValues") or []):
                print(f"    {v['name']:24s} {(v.get('description') or '')[:70]}")
            for v in (t.get("fields") or []):
                print(f"    field: {v['name']}")
            print()
    if not found:
        print("  no license type found by name — trying a top-level licenses query\n")
        r = gql("{ licenses { code name } }")
        print(f"  {json.dumps(r)[:600]}\n")

    # --- fall back to observation -------------------------------------------
    # If the schema won't name the codes, read them off designs that already
    # carry the license we need.
    print("== observed on existing CC BY-NC designs ==")
    r = gql("""
    { creations(limit: 8, sort: BY_PUBLICATION) {
        name
        license { code name }
    } }""")
    print(f"  {json.dumps(r)[:800]}")

    print("\n  >>> S3: the code matching 'CC BY-NC' is what licenses.py maps to.")
    print("\nDone. Paste this whole output back.")


if __name__ == "__main__":
    main()
