#!/usr/bin/env python3
"""Report what each index step of the adjustable tilt actually aims at.

IT READS ITS CONSTANTS OUT OF thermal_cam_mount_common.scad. It used to carry its
own copies and they drifted: it modelled a 60 deg upright cradle long after the
design became a hung tray, and reported PASS throughout — including in two
release notes. Do not reintroduce literals here.
"""
import math, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = re.sub(r"//[^\n]*", "", open(os.path.join(HERE, "thermal_cam_mount_common.scad")).read())


def const(name):
    m = re.search(rf"\b{name}\s*=\s*([-0-9.]+)\s*;", SRC)
    if not m:
        sys.exit(f"verify_aim: {name} not found in the .scad — the model changed shape")
    return float(m.group(1))


TAB_T, FIT, PLATE_T = const("TAB_T"), const("FIT"), const("PLATE_T")
TRAY_T, TILT = const("TRAY_T"), const("TRAY_TILT")
CAM_H, CAM_CLR, BORDER = const("CAM_H"), const("CAM_CLR"), const("BORDER")
WIN_W, WIN_D = const("WIN_W"), const("WIN_D")
PIV_Y, PIVOT_IN = const("PIV_Y"), const("PIVOT_IN")
TILT_MIN, TILT_MAX, TILT_STEP = const("TILT_MIN"), const("TILT_MAX"), const("TILT_STEP")
FOV_V = 42.0        # vertical field of view — the only figure not in the .scad

TRAY_D = CAM_H + CAM_CLR + 2 * BORDER
half = TAB_T / 2 + FIT / 2
bot_z0 = -half - PLATE_T
PIV_Z = bot_z0 - 34.0            # matches PIV_Z = bot_z0 - 34 in the .scad
PIV_LY, PIV_LZ = -TRAY_D / 2 + PIVOT_IN, TRAY_T / 2


def lens_at(t):
    a = math.radians(t)
    oy, oz = -PIV_LY, TRAY_T - PIV_LZ
    return (PIV_Y + oy * math.cos(a) + oz * math.sin(a),
            PIV_Z - oy * math.sin(a) + oz * math.cos(a),
            -math.sin(a), -math.cos(a))


ok = True
print(f"tray pivots at y={PIV_Y:.1f} z={PIV_Z:.2f}, indexed "
      f"{TILT_MIN:.0f}-{TILT_MAX:.0f} deg in {TILT_STEP:.0f} deg steps")
print("the scope's optical axis is y=0; +ve means the thermal lands outboard of it\n")

dists = [50, 70, 90, 110, 130]
print("   hole  tilt   lens y  crosses  " + "".join(f"{d:>9d}" for d in dists))
print("  " + "-" * (31 + 9 * len(dists)))
n = int((TILT_MAX - TILT_MIN) / TILT_STEP) + 1
for i in range(n):
    t = TILT_MIN + i * TILT_STEP
    ly, lz, dy, dz = lens_at(t)
    cross = ly / math.tan(math.radians(t))
    row = "".join(f"{ly - d * math.tan(math.radians(t)):+9.1f}" for d in dists)
    print(f"  {i+1:5d} {t:5.0f}° {ly:8.2f} {cross:8.1f}  {row}")
    if dz >= 0 or dy >= 0:
        print(f"     FAIL step {t:.0f} does not point down and inward")
        ok = False

ly, lz, dy, dz = lens_at(TILT)
print(f"\nset tilt {TILT:.0f}° -> lens y={ly:.2f} z={lz:.2f}, "
      f"axes cross {ly / math.tan(math.radians(TILT)):.1f} mm below the lens")
if abs(math.degrees(math.atan2(abs(dy), abs(dz))) - TILT) > 0.05:
    print("  FAIL aim does not equal TRAY_TILT")
    ok = False
else:
    print("  ok  aim equals TRAY_TILT")

spread = TRAY_T * math.tan(math.radians(FOV_V / 2))
clear = WIN_D / 2 - spread
if clear <= 0:
    print("  FAIL the floor vignettes the view cone")
    ok = False
else:
    print(f"  ok  view cone clears the window by {clear:+.2f} mm")

print("\n" + ("PASS" if ok else "FAIL"))
sys.exit(0 if ok else 1)
