#!/usr/bin/env python3
"""Fail if the cradle cannot hold the camera.

verify_aim.py checks where the lens POINTS. Nothing checked whether the cradle
can keep the camera in it, and that is what shipped in v1.0.1: every retaining
feature topped out at z 19.00 while the camera's centre of mass sat at z 22.00,
on a cradle tilted 60 deg so gravity pulls the body out the open front. The mesh
was valid, the bbox was right, and verify_aim.py passed.

A cradle retains a part when there is material in front of it reaching ABOVE its
centre of mass. Below that, the part pivots over the top of the walls and levers
itself out no matter how much wall is underneath.

This probes the real _cradle() with OpenSCAD booleans rather than re-deriving the
geometry in Python, so it cannot drift from the model.

SPDX-License-Identifier: MIT
Copyright (c) 2026 Aaron Cupp
"""
import os
import re
import struct
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
COMMON = os.path.join(HERE, "thermal_cam_mount_common.scad")

PROBE = """
include <thermal_cam_mount_common.scad>
$fn = 48;
iw = CAM_W + CAM_CLR; id = CAM_D + CAM_CLR;
ow = iw + 2*WALL;     oy = id + 2*WALL;
// everything in the cradle's own frame, before the tilt.
// the camera occupies x -iw/2..iw/2, y WALL..WALL+id, z LIP..LIP+CAM_H
intersection() {
    _cradle();
    translate([-ow, -oy, -1]) cube([2*ow, oy + WALL, 1000]);   // in FRONT of it
}
"""


def const(name):
    """Read a top-level numeric constant out of the common .scad."""
    src = open(COMMON).read()
    m = re.search(r"^\s*%s\s*=\s*([0-9.]+)\s*;" % name, src, re.M)
    if not m:
        m = re.search(r"\b%s\s*=\s*([0-9.]+)\s*;" % name, src)
    if not m:
        sys.exit("cannot find %s in %s" % (name, COMMON))
    return float(m.group(1))


def openscad():
    for c in ("openscad", "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"):
        if subprocess.run(["which", c], capture_output=True).returncode == 0 or os.path.exists(c):
            return c
    sys.exit("openscad not found")


def front_material_z():
    """z range of cradle material standing in front of the camera. None if empty."""
    with tempfile.TemporaryDirectory() as d:
        scad = os.path.join(HERE, "_check_retention_probe.scad")
        stl = os.path.join(d, "probe.stl")
        open(scad, "w").write(PROBE)
        try:
            subprocess.run([openscad(), "-o", stl, "--export-format", "binstl", scad],
                           capture_output=True)
        finally:
            os.remove(scad)
        if not os.path.exists(stl):
            return None
        f = open(stl, "rb")
        f.read(80)
        n = struct.unpack("<I", f.read(4))[0]
        zs = []
        for _ in range(n):
            v = struct.unpack("<12f", f.read(50)[:48])[3:]
            zs += [v[2], v[5], v[8]]
        return (min(zs), max(zs)) if zs else None


def main():
    lip, cam_h = const("LIP"), const("CAM_H")
    cam_lo, cam_hi = lip, lip + cam_h
    com = (cam_lo + cam_hi) / 2

    print("camera        z %6.2f .. %6.2f    centre of mass z %6.2f" % (cam_lo, cam_hi, com))

    front = front_material_z()
    if front is None:
        print("retention     NOTHING in front of the camera")
        print("\nFAIL  the camera is not held at all")
        return 1
    print("retention     z %6.2f .. %6.2f" % front)

    margin = front[1] - com
    print("\nretention reaches %+.2f mm relative to the centre of mass" % margin)
    if margin <= 0:
        print("FAIL  every grip sits below the centre of mass — the camera will")
        print("      pivot over the top of the walls and lever itself out.")
        print("      Raise SIDE_H until the front tabs clear z %.2f." % com)
        return 1
    grip = min(front[1], cam_hi) - cam_lo
    print("PASS  %.1f mm of the camera's %.1f mm height is gripped (%.0f%%)"
          % (grip, cam_h, grip / cam_h * 100))
    return 0


if __name__ == "__main__":
    sys.exit(main())
