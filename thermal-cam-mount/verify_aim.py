#!/usr/bin/env python3
"""Check the thermal cam's aim against the geometry that is actually in the model.

IT READS ITS CONSTANTS OUT OF thermal_cam_mount_common.scad. It used to carry its
own copies, and they drifted: it modelled a 60 deg upright cradle with ARM_FWD
19.5 and the pre-caliper camera long after the design became a 14 deg flat tray
at ARM_FWD 26. It reported PASS the whole time, including in two release notes.
A checker with its own copy of the numbers is a checker that will eventually
validate a part that does not exist. Do not reintroduce literals here.
"""
import math, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
_RAW = open(os.path.join(HERE, "thermal_cam_mount_common.scad")).read()
# Strip // comments first: several constants are discussed in prose above their
# definition, and a comment mentioning a number must never be read as the value.
SRC = re.sub(r"//[^\n]*", "", _RAW)


def const(name):
    # NOT anchored to line start — the .scad packs several onto one line, e.g.
    # "CAM_W = 42.36; CAM_H = 34.35; CAM_D = 13.43;"
    m = re.search(rf"\b{name}\s*=\s*([-0-9.]+)\s*;", SRC)
    if not m:
        sys.exit(f"verify_aim: {name} not found in the .scad — the model changed shape")
    return float(m.group(1))


TAB_T, FIT, PLATE_T = const("TAB_T"), const("FIT"), const("PLATE_T")
TAB_FB, ARM_FWD = const("TAB_FB"), const("ARM_FWD")
TILT, TRAY_T = const("TRAY_TILT"), const("TRAY_T")
CAM_D, CAM_H, CAM_CLR = const("CAM_D"), const("CAM_H"), const("CAM_CLR")
WIN_W, WIN_D = const("WIN_W"), const("WIN_D")
BORDER = const("BORDER")
FOV_V = 42.0        # vertical field of view, degrees — the only figure not in the .scad

TRAY_D = CAM_H + CAM_CLR + 2 * BORDER
half = TAB_T / 2 + FIT / 2
y_front = TAB_FB / 2
bot_z0 = -half - PLATE_T
TRAY_DROP = ((TRAY_D / 2) * math.sin(math.radians(TILT))
             + (TRAY_T + CAM_D + CAM_CLR) * math.cos(math.radians(TILT)) + 3)
cr_y, cr_z = y_front + ARM_FWD, bot_z0 - TRAY_DROP

th = math.radians(-TILT)
c, s = math.cos(th), math.sin(th)


def to_world(y, z):
    return (y * c - z * s + cr_y, y * s + z * c + cr_z)


ok = True
print(f"tray tilt {TILT:.0f} deg, hung {TRAY_DROP:.2f} below the bottom plate")

# The camera lies on the tray floor and looks DOWN through the window.
lens = to_world(0.0, TRAY_T)
dy, dz = (0.0 * c - (-1.0) * s), (0.0 * s + (-1.0) * c)
ang = math.degrees(math.atan2(abs(dy), abs(dz)))
print(f"lens centre        y={lens[0]:7.2f}  z={lens[1]:7.2f}")
print(f"lens vector        dY={dy:+.3f} dZ={dz:+.3f}  -> {ang:.1f} deg from vertical, "
      f"{'INWARD' if dy < 0 else 'OUTWARD'}, {'DOWN' if dz < 0 else 'UP'}")

if dz >= 0:
    print("  FAIL lens points UP"); ok = False
if dy >= 0:
    print("  FAIL lens points away from the optical axis"); ok = False
if abs(ang - TILT) > 0.05:
    print(f"  FAIL aim is {ang:.2f} but the tray tilts {TILT:.2f}"); ok = False

# The view cone must clear the window cut in the tray floor, or the floor vignettes it.
spread = TRAY_T * math.tan(math.radians(FOV_V / 2))
print(f"\nwindow {WIN_W:.0f} x {WIN_D:.0f}, floor {TRAY_T:.1f} thick")
print(f"  cone spreads {spread:.2f} mm per side over the floor's thickness")
for name, w in (("across the window's width", WIN_W), ("across its depth", WIN_D)):
    clear = w / 2 - spread
    flag = "ok " if clear > 0 else "FAIL"
    if clear <= 0:
        ok = False
    print(f"  {name:28s} clearance {clear:+7.2f}  {flag}")

# The camera must sit over the window, not over solid floor.
print(f"\ncamera {CAM_D:.2f} deep on a {TRAY_D:.2f} mm tray — the window is inset "
      f"{(TRAY_D - WIN_D) / 2:.2f} mm from each edge")
if WIN_D >= TRAY_D:
    print("  FAIL window is not inside the tray"); ok = False
else:
    print("  ok  window sits inside the tray's footprint")

print("\n" + ("PASS" if ok else "FAIL"))
sys.exit(0 if ok else 1)
