#!/usr/bin/env python3
"""Fail if nothing holds the camera DOWN in the tray.

This existed once, for the upright cradle, and caught exactly this class of bug.
Then the cradle was replaced by a tray on a branch cut from main, the old branch
was closed, and the check went with it. The tray shipped with plain 4x4 corner
pins — they fenced the camera at four corners and nothing reached over it, so on
a 14 deg tray it slid to the low pair and lifted straight out. The user found it
by putting the camera in.

A tray retains a camera when there is material DIRECTLY ABOVE its seated
footprint. Fencing is not retention: posts that only touch the edges leave the
part free to lift, and the tilt guarantees it will.

Probes the real geometry with OpenSCAD booleans rather than re-deriving it.

    python3 check_retention.py

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
SRC = open(os.path.join(HERE, "thermal_cam_mount_common.scad")).read()


def c(name):
    m = re.search(r"(?m)^\s*%s\s*=\s*([0-9.]+)\s*;" % name, SRC) \
        or re.search(r"\b%s\s*=\s*([0-9.]+)\s*;" % name, SRC)
    if not m:
        sys.exit("cannot read %s" % name)
    return float(m.group(1))


CAM_W, CAM_H, CAM_D, CAM_CLR = c("CAM_W"), c("CAM_H"), c("CAM_D"), c("CAM_CLR")
TRAY_T = c("TRAY_T")

PROBE = """
include <thermal_cam_mount_common.scad>
$fn = 64;
// A slab spanning the camera's footprint, sitting just ABOVE its top face.
// Anything of the mount inside this slab is material hooking over the camera.
module _cam_frame() {
    translate([0, cr_y, cr_z]) rotate([-TRAY_TILT, 0, 0]) children();
}
intersection() {
    mount_bottom();
    _cam_frame() translate([-CAM_W/2, -CAM_H/2, TRAY_T + CAM_D + 0.2])
        cube([CAM_W, CAM_H, %0.2f]);
}
"""


def overhang_volume(depth):
    scad = os.path.join(HERE, "_check_retention_probe.scad")
    open(scad, "w").write(PROBE % depth)
    try:
        with tempfile.TemporaryDirectory() as d:
            stl = os.path.join(d, "p.stl")
            subprocess.run(["openscad", "-o", stl, "--export-format", "binstl", scad],
                           capture_output=True)
            if not os.path.exists(stl):
                return 0.0
            f = open(stl, "rb")
            f.read(80)
            n = struct.unpack("<I", f.read(4))[0]
            v = 0.0
            for _ in range(n):
                a = struct.unpack("<12f", f.read(50)[:48])[3:]
                p1, p2, p3 = a[0:3], a[3:6], a[6:9]
                v += (p1[0]*(p2[1]*p3[2]-p3[1]*p2[2])
                      - p2[0]*(p1[1]*p3[2]-p3[1]*p1[2])
                      + p3[0]*(p1[1]*p2[2]-p2[1]*p1[2])) / 6.0
            return abs(v)
    finally:
        if os.path.exists(scad):
            os.remove(scad)


def main():
    print("camera %g x %g x %g, seated on a %g mm tray" % (CAM_W, CAM_H, CAM_D, TRAY_T))
    v = overhang_volume(6.0)
    print("material hooking over the camera: %.0f mm3" % v)
    if v < 20:
        print("\nFAIL  nothing reaches over the camera — it is only FENCED.")
        print("      Corner posts stop it sliding sideways and do nothing about")
        print("      lifting out, which a tilted tray guarantees.")
        return 1
    print("PASS  the camera is captured, not merely fenced")
    return 0


if __name__ == "__main__":
    sys.exit(main())
