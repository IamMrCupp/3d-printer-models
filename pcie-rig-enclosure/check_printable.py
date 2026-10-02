#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Aaron Cupp
"""Does every layer of a part stand on the layer below it?

Slices each part, IN ITS PRINT ORIENTATION, every DZ mm from the bed up, and
asks of each slice: how much of it lies outside the layer below grown by DZ
(a 45-degree overhang allowance), and how FAR is that material from the
nearest support? A floor over a 15 mm cell is a bridge with 7.5 mm of reach
and prints fine; a 1.6 mm rib hanging 84 mm between two feet has 42 mm of
reach and prints as spaghetti. Reach is what gets flagged.

Why this exists: rig_base v1 was corner feet + ribs + a floor, printed
feet-down. Everything but the feet started 2.8 mm up in mid-air and bridged
84 mm along every edge. Per-part validation (watertight, manifold, bbox) was
happy; the slicer was happy; the print was spaghetti and 125 g went in the
bin (2026-09-30). This check would have flagged 2,000+ mm2 at z = 2.8.

    pcie-rig-enclosure/check_printable.py            # all parts, exits 1 on a flag
    pcie-rig-enclosure/check_printable.py rig_base   # one part

Tolerances: a layer is accepted only if its unsupported material is both
within MAX_REACH of support AND under MAX_AREA in total. The first rule
catches a rib hanging in air; the second catches a floor made of many short
bridges — which is what the second scrapped base was, and which the first
version of this check waved through.
Needs openscad on PATH and trimesh + shapely (the repo's .venv has both).
"""
import subprocess, sys, tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
try:
    import numpy as np
    import shapely
    import trimesh
    from shapely.geometry import Polygon
    from shapely.ops import unary_union
except ImportError:
    sys.exit("check_printable: needs trimesh, shapely, rtree, networkx — run with .venv/bin/python")

DZ = 1.0          # mm between slices; also the 45-degree growth allowance
MIN_AREA = 40.0   # mm2 of unsupported material per layer before it is even looked at
MAX_REACH = 10.0  # mm from the farthest unsupported point to support (= a 20 mm bridge — a
                  # one-layer bridge over a wall cutout is fine; a rib hanging 63 mm is not)
MAX_AREA = 1500.0 # mm2 of unsupported material in ONE layer, whatever its reach. The
                  # second scrapped base had 12,000 mm2 of 15 mm bridges — every span
                  # "short", the layer still a sheet of PETG hanging in air (2026-10-01)
GRID = 1.0        # mm sampling for the reach measurement
Z_TOP = 60.0      # highest layer worth checking (all parts are shorter)

PARTS = ["rig_base", "rig_cup", "rig_storage_bin", "rig_bin_key", "rig_dock_rail",
         "coupons/deck_coupon", "coupons/meter_fuse_coupon", "coupons/xt60_coupon",
         "coupons/joint_coupon", "coupons/dock_rail_ladder"]

def slice_at(mesh, z):
    """The solid cross-section at height z, in WORLD x/y (not the library's
    per-slice local frame — comparing layers needs one frame)."""
    sec = mesh.section(plane_origin=[0, 0, z], plane_normal=[0, 0, 1])
    if sec is None:
        return Polygon()
    flat = trimesh.path.Path2D(entities=sec.entities, vertices=sec.vertices[:, :2])
    polys = [Polygon(p.exterior.coords, [i.coords for i in p.interiors]) for p in flat.polygons_full]
    return unary_union(polys).buffer(0) if polys else Polygon()

def reach(unsupported, support):
    """Farthest any unsupported point is from support, sampled on a grid."""
    minx, miny, maxx, maxy = unsupported.bounds
    xs = np.arange(minx, maxx + GRID, GRID); ys = np.arange(miny, maxy + GRID, GRID)
    gx, gy = np.meshgrid(xs, ys)
    pts = shapely.points(gx.ravel(), gy.ravel())
    inside = shapely.contains(unsupported, pts)
    if not inside.any():
        return 0.0
    return float(shapely.distance(pts[inside], support).max())

def check(stl):
    m = trimesh.load(stl)
    zmax = min(m.bounds[1][2], Z_TOP)
    flags = []
    below = slice_at(m, 0.2)
    z = 0.2 + DZ
    while z < zmax - 0.05:
        here = slice_at(m, z)
        unsupported = here.difference(below.buffer(DZ))
        if unsupported.area >= MIN_AREA:
            r = reach(unsupported, below)
            if r > MAX_REACH or unsupported.area > MAX_AREA:
                flags.append((z, unsupported.area, r))
        below = here
        z += DZ
    return flags

def main(names):
    bad = 0
    with tempfile.TemporaryDirectory() as td:
        for name in names:
            scad = HERE / f"{name}.scad"
            stl = Path(td) / (name.replace("/", "_") + ".stl")
            r = subprocess.run(["openscad", "-o", str(stl), "--export-format", "binstl", str(scad)],
                               capture_output=True, text=True)
            if not stl.exists():
                print(f"ERROR  {name}: did not render\n{r.stderr[-400:]}"); bad += 1; continue
            flags = check(stl)
            if flags:
                bad += 1
                worst = max(flags, key=lambda f: f[2])
                print(f"FAIL {name:28s} unsupported material at {len(flags)} layer(s); worst z={worst[0]:.1f}: {worst[1]:.0f} mm2, {worst[2]:.0f} mm from support")
                for z, a, r in flags[:6]:
                    print(f"       z={z:5.1f}  {a:8.0f} mm2  reach {r:5.1f} mm")
            else:
                print(f"ok   {name:28s} every layer stands on the one below")
    print("—")
    print("check_printable:", "clean" if not bad else f"{bad} part(s) flagged")
    return 1 if bad else 0

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:] or PARTS))
