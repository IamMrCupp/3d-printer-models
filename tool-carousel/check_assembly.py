#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Aaron Cupp
"""Assembly check for the tool carousel: bearings, tools, base and dock in place.

    python3 tool-carousel/check_assembly.py [-D NAME=VALUE ...]

Per-part checks (watertight, one body, overhang) cannot see two parts colliding,
and an empty intersection passes just as happily on a feature that isn't there.
So every "must be empty" check here is paired with a "must be material" probe,
and the script is negative-tested: `--selftest` re-runs it with geometry known to
be wrong and expects failures.

Every number comes from tool_carousel_common.scad via `include` — no copies.
Probes are inset 0.05–0.1 mm from shared faces so a touching face can't read as
a collision.
"""
from __future__ import annotations

import os
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
COMMON = HERE / "tool_carousel_common.scad"
OPENSCAD = os.environ.get("OPENSCAD") or next(
    (p for p in ("openscad", "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD")
     if subprocess.run(["which", p], capture_output=True).returncode == 0 or Path(p).exists()),
    "openscad")

# name, kind ('empty' | 'material'), min volume for 'material', openscad body
CHECKS = [
    ("carousel vs base", "empty", 0, """
        intersection(){ base(); translate([0,0,BASE_T+GAP]) carousel(); }"""),
    ("bearings vs carousel hub", "empty", 0, """
        intersection(){ carousel(); _bearings(0.05); }"""),
    # 0.1 mm push across ~42 mm² of inner-race contact ≈ 4.2 mm³
    ("lower bearing rests on the shoulder (inner race)", "material", 2, """
        intersection(){ translate([0,0,-BASE_T-GAP+0.1]) base(); _bearing_ring(BRG_ID+0.1, BRG_RACE, 0); }"""),
    ("outer races clear of the base", "empty", 0, """
        intersection(){ translate([0,0,-BASE_T-GAP+0.1]) base(); _bearing_ring(BRG_RACE+0.5, BRG_OD, 0); }"""),
    ("upper bearing is on the post (>= 6 mm engaged)", "material", 300, """
        intersection(){ translate([0,0,-BASE_T-GAP]) base(); translate([0,0,HUB_TOP-BRG_W]) cylinder(d=BRG_ID, h=BRG_W); }"""),
    ("post clear of the hub roof", "empty", 0, """
        intersection(){ translate([0,0,-BASE_T-GAP]) base(); difference(){ carousel(); translate([0,0,-1]) cylinder(d=SEAT_D-0.1, h=HUB_TOP+0.9); } }"""),
    ("tools vs carousel", "empty", 0, """
        intersection(){ carousel(); _tools(0.1); }"""),
    # one probe per tool group: a combined probe passes if any one group is seated
    ("outer-ring tools reach their hole floors", "material", 1, """
        intersection(){ carousel(); translate([0,0,-0.2]) _ring_tools(0.1, false); }"""),
    ("bit blocks sit on their pocket floors", "material", 1, """
        intersection(){ carousel(); translate([0,0,-0.2]) _blocks(0.1); }"""),
    ("tweezers reach their slot floors", "material", 1, """
        intersection(){ carousel(); translate([0,0,-0.2]) _tweezers(0.1); }"""),
    ("GameBit handle vs its neighbours", "empty", 0, """
        intersection(){ _gamebit_handle(); _tools_except_gamebit(0); }"""),
    ("base vs dock (seated on its feet)", "empty", 0, """
        intersection(){ dock(); _on_dock() base(); }"""),
    ("carousel clears the dock rim", "empty", 0, """
        intersection(){ dock(); _on_dock() translate([0,0,BASE_T+GAP]) carousel(); }"""),
    ("feet sit on the dock floor", "material", 1, """
        intersection(){ dock(); translate([0,0,-0.1]) _on_dock() _feet(); }"""),
]

HELPERS = """
module _bearing_ring(id, od, z) { translate([0,0,z]) difference(){ cylinder(d=od, h=BRG_W); translate([0,0,-1]) cylinder(d=id, h=BRG_W+2); } }
// both bearings where the hub puts them, shrunk by i each side
module _bearings(i) { _bearing_ring(BRG_ID+2*i, BRG_OD-2*i, 0); _bearing_ring(BRG_ID+2*i, BRG_OD-2*i, HUB_TOP-BRG_W); }
module _gamebit_handle() { for (r = RING) if (r[2] == GAMEBIT_R) rotate([0,0,r[0]]) translate([r[2],0,H1+0.05]) cylinder(d=GAMEBIT_HANDLE, h=90); }
module _ring_tools(i, skip_gamebit) {
    for (r = RING) rotate([0,0,r[0]]) translate([r[2],0,0]) {
        if (r[2] == GAMEBIT_R) {
            if (!skip_gamebit) {
                translate([0,0,H1-GAMEBIT_SHAFT_L]) cylinder(d=GAMEBIT_SHAFT-2*i, h=GAMEBIT_SHAFT_L-0.05);
                translate([0,0,H1+0.05]) cylinder(d=GAMEBIT_HANDLE, h=90);
            }
        } else {
            d = abs(r[1]-(DRIVER_D+HOLE_CLR))<0.01 ? DRIVER_D : abs(r[1]-(BRUSH_D+HOLE_CLR))<0.01 ? BRUSH_D : PICK_D;
            translate([0,0,H1-r[3]]) cylinder(d=d-2*i, h=120);
        }
    }
}
module _blocks(i) { for (k=[0:N_BLOCKS-1]) rotate([0,0,45+k*360/N_BLOCKS])
    translate([BLOCK_IN+BLOCK_CLR/2+i, -BLOCK_L/2+i, H2-BLOCK_DEPTH]) cube([BLOCK_W-2*i, BLOCK_L-2*i, BLOCK_H]); }
module _tweezers(i) { for (k=[0:N_TWEEZERS-1]) rotate([0,0,k*360/N_TWEEZERS])
    translate([SLOT_IN+SLOT_CLR+i, -TWEEZER_T/2+i, H3-SLOT_DEPTH]) cube([TWEEZER_W-2*i, TWEEZER_T-2*i, 80]); }
module _tools(i) { _ring_tools(i, false); _blocks(i); _tweezers(i); }
module _tools_except_gamebit(i) { _ring_tools(i, true); _blocks(i); _tweezers(i); }
module _feet() { for (k=[0:N_FEET-1]) rotate([0,0,45+k*360/N_FEET]) translate([FOOT_R,0,-FOOT_PROUD]) cylinder(d=FOOT_D, h=FOOT_PROUD); }
// base standing on its feet on the dock floor
module _on_dock() { translate([0,0,BIN_BASE_H+DOCK_FLOOR+FOOT_PROUD]) children(); }
"""


def run(defines: list[str]) -> list[tuple[str, bool, str]]:
    results = []
    with tempfile.TemporaryDirectory() as td:
        for name, kind, vmin, body in CHECKS:
            scad = Path(td) / "probe.scad"
            scad.write_text(f"include <{COMMON}>\n{HELPERS}\n{body}\n")
            stl = Path(td) / "probe.stl"
            if stl.exists():
                stl.unlink()
            cmd = [OPENSCAD, "--export-format", "binstl", "-o", str(stl)]
            for d in defines:
                cmd += ["-D", d]
            out = subprocess.run(cmd + [str(scad)], capture_output=True, text=True)
            log = out.stdout + out.stderr
            if "Assertion" in log and "failed" in log:
                results.append((name, False, "design assert failed: " + next(l for l in log.splitlines() if "Assertion" in l)))
                continue
            empty = "Current top level object is empty" in log or not stl.exists() or stl.stat().st_size < 200
            vol = 0.0
            if not empty:
                import trimesh  # noqa: PLC0415
                m = trimesh.load(stl)
                vol = abs(m.volume)
                if min(m.extents) < 1e-3:   # a coincident face, zero thickness: contact, not overlap
                    vol = 0.0
            if kind == "empty":
                ok = vol < 0.5
                results.append((name, ok, "empty" if ok else f"{vol:.1f} mm³ of overlap"))
            else:
                ok = vol >= vmin
                results.append((name, ok, f"{vol:.1f} mm³ present" if ok else f"only {vol:.1f} mm³ — the feature is missing"))
    return results


def main() -> int:
    args = sys.argv[1:]
    if args and args[0] == "--selftest":
        # each breaks one thing GEOMETRICALLY, without tripping a design assert —
        # an assert firing would "catch" it without proving the probe works
        bad = {
            "SEAT_D=21.8": "bearings vs carousel hub",
            "HOLE_CLR=-0.3": "tools vs carousel",
            "POST_TOP=10": "upper bearing is on the post (>= 6 mm engaged)",
            "DOCK_POCKET_D=118": "base vs dock (seated on its feet)",
            "BLOCK_CLR=-1.0": "tools vs carousel",
            "SLOT_CLR=-0.6": "tools vs carousel",
        }
        failed = 0
        for d, expect in bad.items():
            out = run([d])
            if any("design assert" in m for _, _, m in out):
                print(f"  BAD  -D {d}: tripped a design assert, so it tests nothing — pick another"); failed += 1; continue
            res = {n: ok for n, ok, _ in out}
            caught = not res.get(expect, True)
            print(f"  {'ok  ' if caught else 'MISS'} -D {d}: {'caught' if caught else 'NOT caught'} "
                  f"({', '.join(n for n, ok in res.items() if not ok) or 'nothing failed'})")
            failed += not caught
        return 1 if failed else 0
    defines = [a for a in args if "=" in a]
    results = run(defines)
    for name, ok, msg in results:
        print(f"  {'PASS' if ok else 'FAIL'}  {name}: {msg}")
    return 0 if all(ok for _, ok, _ in results) else 1


if __name__ == "__main__":
    sys.exit(main())
