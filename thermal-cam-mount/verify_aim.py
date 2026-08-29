#!/usr/bin/env python3
"""Assert the thermal cam's lens points DOWN and INWARD, that its sight line
clears the top plate's front-top corner, and that nothing dips into the working
volume between the objective and the board — at EVERY settable tilt.

Two things changed here after v1.0.1:

1. It reads the constants out of thermal_cam_mount_common.scad instead of
   keeping its own hand-copied set. The old copy still said the cradle topped
   out at 19 after the walls went to 30. A checker with its own copy of the
   numbers is a checker that eventually checks the wrong model.

2. It sweeps the whole index range, not just the current CAM_ANGLE. The tilt is
   now chosen at assembly, so "it aims correctly" has to be true for every hole
   the user can put the screw through, not only the one that happens to be set.

SPDX-License-Identifier: MIT
Copyright (c) 2026 Aaron Cupp
"""
import math
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = open(os.path.join(HERE, "thermal_cam_mount_common.scad")).read()


def c(name):
    m = re.search(r"(?m)^\s*%s\s*=\s*(-?[0-9.]+)\s*;" % name, SRC) \
        or re.search(r"\b%s\s*=\s*(-?[0-9.]+)\s*;" % name, SRC)
    if not m:
        sys.exit("cannot read %s from thermal_cam_mount_common.scad" % name)
    return float(m.group(1))


CAM_D, CAM_H, CAM_CLR, WALL = c("CAM_D"), c("CAM_H"), c("CAM_CLR"), c("WALL")
TAB_FB, TAB_T, FIT, PLATE_T = c("TAB_FB"), c("TAB_T"), c("FIT"), c("PLATE_T")
ARM_FWD, ARM_UP, LIP = c("ARM_FWD"), c("ARM_UP"), c("LIP")
SIDE_H, BACK_H, PIV_Z, PAD_R = c("SIDE_H"), c("BACK_H"), c("PIV_Z"), c("PAD_R")
A_MIN, A_MAX, A_STEP = c("CAM_ANGLE_MIN"), c("CAM_ANGLE_MAX"), c("CAM_ANGLE_STEP")
CAM_ANGLE, REF_TILT = c("CAM_ANGLE"), c("REF_TILT")

half = TAB_T / 2 + FIT / 2
y_front = TAB_FB / 2
top_z1 = half + PLATE_T
cr_y, cr_z = y_front + ARM_FWD, top_z1 + ARM_UP
CR_OY = CAM_D + CAM_CLR + 2 * WALL


def rot(t, y, z):
    th = math.radians(t)
    return (y * math.cos(th) - z * math.sin(th), y * math.sin(th) + z * math.cos(th))


# pivot in world, derived at REF_TILT so CAM_ANGLE 30 reproduces the old pose
_py, _pz = rot(REF_TILT, CR_OY / 2, PIV_Z)
PIV_WY, PIV_WZ = cr_y + _py, cr_z + _pz


def place(t, y, z):
    """cradle-frame point -> world, for tilt t"""
    dy, dz = rot(t, y - CR_OY / 2, z - PIV_Z)
    return (PIV_WY + dy, PIV_WZ + dz)


def check(angle, verbose):
    t = 90 - angle
    ok = True
    mid_z = LIP + CAM_H / 2
    ly, lz = place(t, WALL, mid_z)                       # lens: the open low-y face
    sy, sz = place(t, WALL + CAM_D + CAM_CLR, mid_z)     # screen: against the back wall
    ny, nz = ly - sy, lz - sz
    m = math.hypot(ny, nz)
    ny, nz = ny / m, nz / m
    ang = abs(math.degrees(math.atan2(-ny, -nz)))

    if verbose:
        print("  lens  y=%7.2f z=%7.2f   dY=%+.3f dZ=%+.3f  -> %.1f deg from vertical, %s, %s"
              % (ly, lz, ny, nz, ang, "INWARD" if ny < 0 else "OUTWARD", "DOWN" if nz < 0 else "UP"))
    if nz >= 0 or ny >= 0:
        ok = False

    # every ray across the 42 deg vertical FOV must clear the plate's front-top corner
    worst = None
    for a in (ang - 21, ang, ang + 21):
        if a <= 0:
            ok = False
            continue
        clr = (lz - (ly - y_front) / math.tan(math.radians(a))) - top_z1
        worst = clr if worst is None else min(worst, clr)
        if clr <= 0:
            ok = False

    # nothing below the tab's top face except the clamp
    pts = [place(t, y, z) for y in (0, CR_OY) for z in (0, max(SIDE_H, BACK_H))]
    lo = min(p[1] for p in pts)
    lo = min(lo, PIV_WZ - PAD_R)          # the joint pad counts too
    if lo < half:
        ok = False
    return ok, ang, worst, lo


print("current CAM_ANGLE = %g" % CAM_ANGLE)
ok_now, ang, worst, lo = check(CAM_ANGLE, True)
print("  FOV clearance over the plate corner: %+.2f mm" % worst)
print("  lowest point z=%.2f   (tab top face z=%.2f)" % (lo, half))

print("\nsweeping every index position — the tilt is set at assembly, so all of")
print("these have to aim correctly, not just the one currently in the file:\n")
print("  %-6s %-10s %-14s %-12s" % ("angle", "aim", "FOV clear", "lowest z"))
allok = True
a = A_MIN
while a <= A_MAX + 1e-9:
    o, g, w, l = check(a, False)
    allok &= o
    print("  %-6g %-10s %-14s %-12s %s"
          % (a, "%.1f deg" % g, "%+.2f" % w, "%.2f" % l, "ok" if o else "FAIL"))
    a += A_STEP

print("\n" + ("PASS" if (allok and ok_now) else "FAIL"))
sys.exit(0 if (allok and ok_now) else 1)
