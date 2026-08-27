#!/usr/bin/env python3
#
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Aaron Cupp
"""Validate a binary STL mesh: watertight / 2-manifold + sane bounding box.

    python3 tools/validate_stl.py path/to/model.stl

Uses **trimesh** when available (authoritative — `is_watertight` /
`is_winding_consistent`), and falls back to a zero-dependency stdlib edge check
so the script still runs locally without a venv. CI installs trimesh
(requirements-dev.txt) so the strong check gates merges.

A mesh passes when:
  * it is watertight (closed) and consistently wound — i.e. 2-manifold
  * no triangle edge is shorter than SLIVER_MM (no near-degenerate slivers)
  * the bounding box is non-degenerate (positive extent on all three axes)
  * a Gridfinity part's outer wall is CONTINUOUS at all four corners

Exit code 0 on pass, 1 on failure (with diagnostics on stderr).
"""
from __future__ import annotations

import math
import struct
import sys
from collections import Counter

# Shortest edge a mesh may contain before it counts as near-degenerate. See the
# sliver check in _validate_stdlib() for why this number.
SLIVER_MM = 1e-3

# Gridfinity cell pitch, and the outer corner radius bin_blank() builds with.
GF_PITCH = 42.0
GF_OUTER_GAP = 0.5          # an n-cell part is n*42 - 0.5 across
GF_CORNER_R = 3.75          # lib/gridfinity.scad BIN_R
CORNER_PROBE_IN = 0.45      # how far inside the outer skin to sample


def load_binary_stl(path: str):
    with open(path, "rb") as fh:
        data = fh.read()
    if len(data) < 84:
        raise ValueError("file too short to be a binary STL")
    if data[:5] == b"solid" and b"facet normal" in data[:512]:
        raise ValueError("looks like ASCII STL; export with --export-format binstl")
    (count,) = struct.unpack("<I", data[80:84])
    expected = 84 + count * 50
    if len(data) != expected:
        raise ValueError(
            f"size mismatch: header says {count} triangles "
            f"(expect {expected} bytes) but file is {len(data)} bytes"
        )
    tris = []
    off = 84
    for _ in range(count):
        v = struct.unpack("<12f", data[off : off + 48])
        tris.append((v[3:6], v[6:9], v[9:12]))
        off += 50
    return tris


def _key(p, ndigits=4):
    return (round(p[0], ndigits), round(p[1], ndigits), round(p[2], ndigits))


def validate(path: str) -> list[str]:
    """Return a list of problems; empty list means the mesh is valid.

    ALWAYS runs the raw-triangle stdlib check (open + non-manifold edges read
    from the actual STL bytes) and then adds trimesh's winding-consistency test
    when trimesh is installed.

    Why always stdlib: trimesh merges near-coincident vertices when it loads a
    mesh, which silently heals coincident-face non-manifold edges — so a mesh
    can pass `trimesh.is_watertight` yet still have 2+ faces sharing an edge in
    the actual STL. The release pipeline runs the stdlib check (no trimesh), so
    PR validation must run it too, or non-manifold meshes pass CI and only blow
    up at release time. (This exact gap shipped a bad owon-tray rail.)
    """
    problems = _validate_stdlib(path)
    try:
        import trimesh
    except ImportError:
        return problems
    mesh = trimesh.load(path, force="mesh")
    if not mesh.is_empty and len(mesh.faces) and not mesh.is_winding_consistent:
        problems.append("inconsistent winding — flipped faces [trimesh]")
    return problems


def _validate_stdlib(path: str) -> list[str]:
    """Zero-dependency fallback: edge-manifold + bbox check from raw triangles."""
    tris = load_binary_stl(path)
    problems = []

    if not tris:
        return ["mesh is empty (0 triangles)"]

    # Edge-manifold check: each undirected edge in exactly two triangles.
    edges = Counter()
    for a, b, c in tris:
        ka, kb, kc = _key(a), _key(b), _key(c)
        for e in ((ka, kb), (kb, kc), (kc, ka)):
            edges[frozenset(e)] += 1
    open_edges = sum(1 for n in edges.values() if n == 1)
    nonmanifold = sum(1 for n in edges.values() if n > 2)
    if open_edges:
        problems.append(f"{open_edges} open edge(s) — mesh is not watertight")
    if nonmanifold:
        problems.append(f"{nonmanifold} non-manifold edge(s) — shared by >2 triangles")

    # Sliver check: no triangle edge shorter than SLIVER_MM.
    #
    # This is the deterministic version of the non-manifold check above. A
    # near-degenerate triangle is what a coincident-wall boolean leaves behind,
    # and whether _key()'s 4-decimal rounding collapses one into a duplicate
    # edge depends on where the mesh happens to sit in space — so the same bug
    # reads as non-manifold at one ($fn, size) and passes at the next. Catching
    # the sliver itself removes the luck. (The Gridfinity foot carried slivers
    # of 5.7e-5 to 1.6e-4 mm for its whole life this way; see
    # lib/selftest_fn.scad.)
    #
    # 1e-3 mm sits in clear air: the shortest legitimate edge across every model
    # in this repo is 3.3e-3 mm, and those come from the e = 0.01 epsilon slabs
    # OpenSCAD models are built from. Nothing printable has micron-scale edges.
    short = min(
        math.dist(p, q)
        for a, b, c in tris
        for p, q in ((a, b), (b, c), (c, a))
    )
    if short < SLIVER_MM:
        problems.append(
            f"sliver triangle — shortest edge {short:.2e} mm "
            f"(under {SLIVER_MM:g} mm); near-degenerate geometry, usually a "
            f"boolean between coincident walls"
        )

    # Bounding-box sanity.
    xs = [p[0] for t in tris for p in t]
    ys = [p[1] for t in tris for p in t]
    zs = [p[2] for t in tris for p in t]
    dims = (max(xs) - min(xs), max(ys) - min(ys), max(zs) - min(zs))
    if min(dims) <= 0:
        problems.append(f"degenerate bounding box: {tuple(round(d, 3) for d in dims)}")

    problems += _corner_wall_problems(tris, dims, (min(xs), min(ys), min(zs)))

    validate.last_summary = (
        f"{len(tris)} triangles, "
        f"bbox {tuple(round(d, 2) for d in dims)} mm [stdlib]"
    )
    return problems


def _ray_hits_x(tris, y, z):
    """X coordinates where a +X ray at (·, y, z) crosses the mesh.

    Cast HORIZONTALLY on purpose. A vertical ray through a Gridfinity part runs
    along the foot's chamfers and clips dozens of near-tangent triangles, which
    makes an even-odd test unreliable — that is not hypothetical, it reported a
    solid foot as hollow. Above the foot the geometry is prismatic (vertical
    walls), so a horizontal ray crosses clean faces.
    """
    hits = []
    for a, b, c in tris:
        # does the triangle straddle this (y, z) line, in the y-z plane?
        d1 = (y - b[1]) * (a[2] - b[2]) - (a[1] - b[1]) * (z - b[2])
        d2 = (y - c[1]) * (b[2] - c[2]) - (b[1] - c[1]) * (z - c[2])
        d3 = (y - a[1]) * (c[2] - a[2]) - (c[1] - a[1]) * (z - a[2])
        if (d1 < 0 or d2 < 0 or d3 < 0) and (d1 > 0 or d2 > 0 or d3 > 0):
            continue
        den = (b[2] - c[2]) * (a[1] - c[1]) + (c[1] - b[1]) * (a[2] - c[2])
        if abs(den) < 1e-12:
            continue
        l1 = ((b[2] - c[2]) * (y - c[1]) + (c[1] - b[1]) * (z - c[2])) / den
        l2 = ((c[2] - a[2]) * (y - c[1]) + (a[1] - c[1]) * (z - c[2])) / den
        l3 = 1.0 - l1 - l2
        hits.append(l1 * a[0] + l2 * b[0] + l3 * c[0])
    return sorted(hits)


def _solid_at(tris, x, y, z):
    """True when (x, y, z) is inside the solid, by a horizontal even-odd test."""
    hits = _ray_hits_x(tris, y, z)
    return sum(1 for h in hits if h > x) % 2 == 1


def _solid_confident(tris, x, y, z):
    """True / False / None(unsure) — inside-solid by two opposing horizontal rays.

    A single ray can run tangent to a faceted corner arc and answer wrongly; that
    is not theoretical, it reported an intact riser-spacer corner as open. Two
    opposing rays that AGREE are trustworthy. When they disagree the sample sits
    on a surface and the answer is None, which callers treat as "do not flag".
    """
    hits = _ray_hits_x(tris, y, z)
    fwd = sum(1 for h in hits if h > x) % 2 == 1
    back = sum(1 for h in hits if h < x) % 2 == 1
    return fwd if fwd == back else None


def _corner_wall_problems(tris, dims, mins) -> list[str]:
    """A Gridfinity part must have material at all four outer corners.

    WHY THIS CHECK EXISTS. bin_blank()'s interior is a ROUNDED rectangle. Cut a
    bay with a plain cube spanning the full interior and the square runs through
    those corner radii and removes the outer wall there — the bin arrives with no
    connected corners.

    Every other check in this file passes such a part: watertight, 2-manifold, no
    slivers, bounding box exactly right, every bay to spec. Two bins shipped and
    were printed that way before anyone looked at a corner. A mesh check tells you
    a part is CLOSED, not that the box is a box.

    HOW IT PROBES. Marching inward along each corner diagonal to FIND the outer
    skin, then sampling just behind it. It does not compute the corner from the
    bounding box: riser_spacer_2in is 84.0 across because of the Clickfinity
    plate on top, while the body under it is 83.5, and assuming the bbox put the
    samples on the skin and called an intact corner open.

    A square cut leaves a hair of wall outside itself, so the first solid hit is
    not proof — the samples go BEHIND the skin, where the cut actually bites.

    DELIBERATELY CONSERVATIVE — it must never cry wolf on a good part:
      * two opposing rays per sample; disagreement is "unsure", never "open"
      * both samples behind the skin must be confidently open
      * a face whose MID-EDGE is open is an open-front design (instrument docks
        sweep a whole wall away) — that face's corners are skipped
    """
    w, d, h = dims
    x0, y0, z0 = mins

    def cells(extent):
        n = (extent + GF_OUTER_GAP) / GF_PITCH
        return round(n) if abs(n - round(n)) < 0.05 and round(n) >= 1 else None

    if cells(w) is None or cells(d) is None:
        return []                      # not a Gridfinity footprint
    if h < 8.0:
        return []                      # a plate — no wall to breach

    z = z0 + min(h - 1.0, max(6.8, h * 0.45))
    cx, cy = x0 + w / 2.0, y0 + d / 2.0

    # A swept-away wall is a design, not a defect. Detect it at the mid-edge.
    def mid_open(px, py):
        return _solid_confident(tris, px, py, z) is False

    open_face = {
        "-y": mid_open(cx, cy - d / 2 + 0.45),
        "+y": mid_open(cx, cy + d / 2 - 0.45),
        "-x": mid_open(cx - w / 2 + 0.45, cy),
        "+x": mid_open(cx + w / 2 - 0.45, cy),
    }

    breached = []
    for sx in (-1, 1):
        for sy in (-1, 1):
            if open_face["+x" if sx > 0 else "-x"] or open_face["+y" if sy > 0 else "-y"]:
                continue               # this corner belongs to an open face

            # march inward along the diagonal until the outer skin is found
            skin = None
            steps = int((min(w, d) / 2.0) / 0.05)
            for k in range(steps):
                t = (min(w, d) / 2.0 + 1.0) - k * 0.05
                if _solid_confident(tris, cx + sx * t, cy + sy * t, z) is True:
                    skin = t
                    break
            if skin is None:
                continue               # never found material — nothing to judge

            deep = [
                _solid_confident(tris, cx + sx * (skin - back), cy + sy * (skin - back), z)
                for back in (0.30, 0.55)
            ]
            if all(v is False for v in deep):
                breached.append(f"({sx * (skin - 0.4):+.0f}, {sy * (skin - 0.4):+.0f})")
    if breached:
        return [
            "outer wall is OPEN at %d of 4 corners %s — a full-depth cut ran "
            "through bin_blank's corner radii. Clip cuts to a rounded interior "
            "prism (see bin_swabs)." % (len(breached), ", ".join(breached))
        ]
    return []


def main(argv) -> int:
    if len(argv) != 2:
        print("usage: validate_stl.py <model.stl>", file=sys.stderr)
        return 2
    path = argv[1]
    try:
        problems = validate(path)
    except (OSError, ValueError) as exc:
        print(f"FAIL {path}: {exc}", file=sys.stderr)
        return 1
    if problems:
        print(f"FAIL {path}: {getattr(validate, 'last_summary', '')}", file=sys.stderr)
        for p in problems:
            print(f"  - {p}", file=sys.stderr)
        return 1
    print(f"PASS {path}: {validate.last_summary}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
