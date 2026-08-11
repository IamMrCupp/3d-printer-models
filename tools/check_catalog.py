#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Aaron Cupp
"""Fail if a model directory isn't carrying its paperwork.

Every model here is supposed to ship the same four things: the parametric .scad
source, a per-model README.md, a Blender preview.png, and a row in the main
README's catalog table. The first one is why the directory exists, so it never
gets forgotten. The other three do, every time — the model works, the model gets
printed, and the catalog quietly stops describing the repo.

This check is the reason that stops happening. It runs on every PR alongside the
mesh validation, so a new model directory can't merge half-documented.

A model directory is any top-level directory holding a .scad file, minus the
shared code (lib/, tools/) and build output. There is deliberately no exemption
list: a directory that isn't ready to be catalogued isn't ready to be on main.

    tools/check_catalog.py          # exits 1 and prints what's missing

"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
NOT_MODELS = {"lib", "tools", "build", "node_modules"}


def model_dirs():
    for p in sorted(ROOT.iterdir()):
        if not p.is_dir() or p.name.startswith(".") or p.name in NOT_MODELS:
            continue
        if any(p.glob("*.scad")):
            yield p


def catalogued(readme_text):
    """Slugs linked from the main README, e.g. `[**Name**](some-model/)`."""
    return set(re.findall(r"\]\(([A-Za-z0-9._-]+)/\)", readme_text))


def main():
    root_readme = ROOT / "README.md"
    if not root_readme.is_file():
        print("check_catalog: no README.md at the repo root", file=sys.stderr)
        return 1

    linked = catalogued(root_readme.read_text(encoding="utf-8"))
    problems = []

    for d in model_dirs():
        slug = d.name
        if not (d / "README.md").is_file():
            problems.append(f"{slug}/README.md is missing")
        if not (d / "preview.png").is_file():
            problems.append(
                f"{slug}/preview.png is missing "
                f"— render one with: tools/preview.sh {slug}/<part>.scad {slug}/preview.png"
            )
        if slug not in linked:
            problems.append(
                f"{slug}/ has no row in the main README catalog table "
                f"— add one linking to `{slug}/` with its preview.png"
            )

    # A row pointing at a directory that no longer exists is the same drift,
    # running the other way.
    for slug in sorted(linked):
        target = ROOT / slug
        if target.is_dir() and not any(target.glob("*.scad")) and slug not in NOT_MODELS:
            problems.append(f"main README links `{slug}/`, which holds no .scad source")
        elif not target.exists():
            problems.append(f"main README links `{slug}/`, which doesn't exist")

    if problems:
        print("Catalog is out of sync with the model directories:\n", file=sys.stderr)
        for p in problems:
            print(f"  - {p}", file=sys.stderr)
        print(
            "\nSee README.md → 'Adding a model'. Every model dir needs a .scad, a "
            "README.md, a preview.png, and a row in the catalog table.",
            file=sys.stderr,
        )
        return 1

    n = len(list(model_dirs()))
    print(f"check_catalog: {n} model dirs, all documented and catalogued")
    return 0


if __name__ == "__main__":
    sys.exit(main())
