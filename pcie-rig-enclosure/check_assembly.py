#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Aaron Cupp
"""Intersect the assembled rig — parts against parts, components against parts.

Per-part validation can't see two parts overlapping, and 2,330 mm3 of
interference once shipped that way. So this places every part where it
lives in the finished box, adds a solid for every electrical component
where it mounts, and renders the pairwise intersections. Every one must be
empty.

Probes are inset 0.05 from any face they share with a part (a coincident
face returns a zero-volume shell that reads as a collision).

    pcie-rig-enclosure/check_assembly.py         # exits 1 on any overlap

Needs openscad on PATH and trimesh (the repo's .venv has it).
"""
import os, subprocess, sys, tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
try:
    import trimesh
except ImportError:
    sys.exit("check_assembly: needs trimesh — run with .venv/bin/python")

# Everything the check needs to know, expressed in OpenSCAD so it stays in
# lock-step with rig_common.scad rather than copying numbers here.
PRELUDE = f"""
use <{HERE}/rig_frame.scad>
use <{HERE}/rig_shelf.scad>
use <{HERE}/rig_cup.scad>
use <{HERE}/rig_drawer.scad>
use <{HERE}/rig_dock_rail.scad>
include <{HERE}/rig_common.scad>
$fn = 48;
Z_FLOOR = BIN_BASE_H + FLOOR_T;
Z_RIM   = Z_FLOOR + BAY_H;
Z_CUP0  = Z_RIM - TONGUE_H;            // cup's skirt bottom
Z_DECK  = Z_CUP0 + CUP_H;              // deck top face
IN      = 0.05;                         // probe inset from shared faces

module P_frame()  rig_frame();
module P_shelf()  translate([0, 0, Z_RIM]) rig_shelf();
module P_cup()    translate([0, 0, Z_CUP0]) rig_cup();
module P_drawer() translate([0, -(D/2) + DRAWER_D/2, Z_FLOOR]) rig_drawer();
module P_rails()  for (sx = [-1, 1])
    translate([RISER_X + sx*RISER_HOLE_PITCH_L/2, RISER_Y, Z_DECK - RAIL_POCKET]) rig_dock_rail();

// components, as solids, where they mount
module C_meter()  translate([METER_X, METER_Y, Z_DECK - METER_DEPTH + IN])
    linear_extrude(METER_DEPTH - 2*IN) square([METER_W, METER_D], center = true);
module C_switch() translate([SW_X, SW_Y, Z_DECK - SW_DEPTH + IN]) cylinder(d = SW_BODY, h = SW_DEPTH - 2*IN);
module C_gnd()    translate([GND_X, GND_Y, Z_DECK - POST_LEN + IN]) cylinder(d = POST_THREAD, h = POST_LEN - 2*IN);
module C_posts()  for (x = [J1_X, J2_X])
    translate([x, D/2 - IN, Z_CUP0 + WALL_Z]) rotate([90, 0, 0]) cylinder(d = POST_THREAD, h = POST_LEN - 2*IN);
module C_fuse()   translate([F1_X, D/2 - IN, Z_CUP0 + WALL_Z]) rotate([90, 0, 0]) cylinder(d = FUSE_THREAD, h = FUSE_LEN - 2*IN);
module C_tails()  translate([W/2 - WALL - 30, TAILS_Y, Z_CUP0 + WALL_Z]) rotate([0, 90, 0]) cylinder(d = TAILS_W, h = 30 + WALL + 20);
module C_riser()  translate([RISER_X, RISER_Y, Z_DECK + IN]) linear_extrude(RISER_T) square([RISER_L, RISER_W], center = true);
// a 2.5 rod down every screw axis: passes the 3.4 clearance AND the 2.6 pilot
module C_screws() for (s = [-1, 1], y = [-BOSS_Y, BOSS_Y])
    translate([s * (W/2 + 2), y, Z_CUP0 + SCREW_Z]) rotate([0, -s*90, 0]) cylinder(d = 2.5, h = 2 + WALL + BOSS_IN + 1);
"""

CHECKS = [
    # (name, A, B) — render intersection(A, B); must be empty
    ("frame x shelf",        "P_frame()",  "P_shelf()"),
    ("frame x cup",          "P_frame()",  "P_cup()"),
    ("shelf x cup",          "P_shelf()",  "P_cup()"),
    ("drawer x frame",       "P_drawer()", "P_frame()"),
    ("drawer x shelf",       "P_drawer()", "P_shelf()"),
    ("drawer x cup",         "P_drawer()", "P_cup()"),
    ("rails x cup",          "P_rails()",  "P_cup()"),
    ("meter x cup",          "C_meter()",  "P_cup()"),
    ("meter x shelf",        "C_meter()",  "P_shelf()"),
    ("switch x cup",         "C_switch()", "P_cup()"),
    ("gnd post x cup",       "C_gnd()",    "P_cup()"),
    ("in posts x cup",       "C_posts()",  "P_cup()"),
    ("fuse x cup",           "C_fuse()",   "P_cup()"),
    ("fuse x meter",         "C_fuse()",   "C_meter()"),
    ("tails x cup",          "C_tails()",  "P_cup()"),
    ("tails x switch/gnd",   "C_tails()",  "union() { C_switch(); C_gnd(); }"),
    ("riser x cup",          "C_riser()",  "P_cup()"),
    ("screw rods x frame+cup", "C_screws()", "union() { P_frame(); P_cup(); }"),
]

def volume(stl):
    if not stl.exists() or stl.stat().st_size < 100:
        return 0.0
    m = trimesh.load(stl)
    return abs(m.volume) if len(m.faces) else 0.0

SELFTEST = ["P_frame()", "P_shelf()", "P_cup()", "P_drawer()", "P_rails()",
            "C_meter()", "C_switch()", "C_gnd()", "C_posts()", "C_fuse()", "C_tails()", "C_riser()", "C_screws()"]

def render(scad, stl):
    r = subprocess.run(["openscad", "-o", str(stl), "--export-format", "binstl", str(scad)],
                       capture_output=True, text=True)
    err = [l for l in r.stderr.splitlines() if "ERROR" in l or "Ignoring unknown" in l or "Can't" in l]
    return err

def main():
    bad = 0
    with tempfile.TemporaryDirectory() as td:
        td = Path(td)
        # Positive controls: every solid must render to something. An empty
        # intersection is only evidence if both operands actually exist.
        for m in SELFTEST:
            scad = td / ("self_" + m.replace("()", "") + ".scad"); stl = scad.with_suffix(".stl")
            scad.write_text(PRELUDE + f"\n{m};\n")
            err = render(scad, stl); v = volume(stl)
            if err or v < 1.0:
                print(f"ERROR  self-test {m}: volume {v:.1f} mm3 {err[:1]}"); bad += 1
        if bad:
            print("check_assembly: self-test failed, intersections not run"); return 1
        print(f"self-test: {len(SELFTEST)} solids render")
        for name, a, b in CHECKS:
            scad = td / (name.replace(" ", "_").replace("/", "_") + ".scad")
            stl = scad.with_suffix(".stl")
            scad.write_text(PRELUDE + f"\nintersection() {{ {a}; {b}; }}\n")
            err = render(scad, stl)
            if err:
                print(f"ERROR  {name}: {err[0]}"); bad += 1; continue
            v = volume(stl)
            ok = v < 0.5   # mm3 — tessellation noise, not a collision
            where = ""
            if not ok:
                m = trimesh.load(stl); lo, hi = m.bounds
                where = f"  bbox x[{lo[0]:.1f},{hi[0]:.1f}] y[{lo[1]:.1f},{hi[1]:.1f}] z[{lo[2]:.1f},{hi[2]:.1f}]"
            print(f"{'ok  ' if ok else 'FAIL'} {name:26s} {v:9.1f} mm3{where}")
            bad += 0 if ok else 1
    print("—")
    print("check_assembly:", "clean" if not bad else f"{bad} overlap(s)")
    return 1 if bad else 0

if __name__ == "__main__":
    sys.exit(main())
