#!/usr/bin/env python3
"""The two printed parts must be able to occupy the assembled position together.

This is the check that did not exist when mount_bottom and mount_tray shipped
overlapping by 2,330 mm3 — every per-part check was green and the parts could
not be joined. It intersects them at EVERY index step and requires the result to
be empty. It also requires the yoke to stay out of the camera's seated volume,
and the index pin to pass through leg and yoke together at every step.
"""
import os, re, struct, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = re.sub(r"//[^\n]*", "", open(os.path.join(HERE, "thermal_cam_mount_common.scad")).read())
def const(n):
    m = re.search(rf"\b{n}\s*=\s*([-0-9.]+)\s*;", SRC)
    if not m: sys.exit(f"check_assembly: {n} missing from the .scad")
    return float(m.group(1))
TMIN, TMAX, TSTEP = const("TILT_MIN"), const("TILT_MAX"), const("TILT_STEP")
STEPS = [TMIN + i*TSTEP for i in range(int((TMAX-TMIN)/TSTEP)+1)]

def render(scad):
    f = tempfile.NamedTemporaryFile(suffix=".scad", delete=False, mode="w"); f.write(scad); f.close()
    out = f.name[:-5] + ".stl"
    r = subprocess.run(["openscad","-o",out,"--export-format","binstl",f.name], capture_output=True, text=True)
    # An EMPTY intersection is the result we WANT, and OpenSCAD exits non-zero
    # for it. Only a real error is fatal.
    if "top level object is empty" in r.stderr:
        open(out, "wb").close()
        return out
    if r.returncode: sys.exit("openscad failed:\n" + r.stderr[-800:])
    return out

def volume(path):
    if not os.path.exists(path) or os.path.getsize(path) < 100: return 0.0, 0, None
    fh = open(path,"rb"); fh.read(80); n = struct.unpack("<I", fh.read(4))[0]
    v = 0.0; lo=[9e9]*3; hi=[-9e9]*3
    for _ in range(n):
        q = struct.unpack("<12f", fh.read(50)[:48])[3:]
        a,b,c = q[0:3],q[3:6],q[6:9]
        v += (a[0]*(b[1]*c[2]-b[2]*c[1]) - a[1]*(b[0]*c[2]-b[2]*c[0]) + a[2]*(b[0]*c[1]-b[1]*c[0]))/6
        for i in range(3):
            for k in range(3): lo[k]=min(lo[k],q[i*3+k]); hi[k]=max(hi[k],q[i*3+k])
    return abs(v), n, [hi[k]-lo[k] for k in range(3)]

HEAD = f'include <{HERE}/thermal_cam_mount_common.scad>\n$fn = 48;\n'
ok = True
print(f"index steps: {[int(t) for t in STEPS]}\n")

for t in STEPS:
    # 1. bottom part vs tray part — must be EMPTY (raw, no inset: any overlap is a defect)
    vol, n, ext = volume(render(HEAD + f"intersection() {{ _arm(); _tray_at({t}); }}"))
    line = f"  {int(t):2d}°  parts overlap: {vol:7.1f} mm3"
    if n:
        ok = False; line += f"  FAIL  (bbox {ext[0]:.1f} x {ext[1]:.1f} x {ext[2]:.1f})"
    else: line += "  ok"
    # 2. yoke/tray vs the camera's seated volume — inset 0.2, must be EMPTY
    vol2, n2, ext2 = volume(render(HEAD + f"""
        module _cam() {{ translate([0,0,TRAY_T+0.2]) linear_extrude(CAM_D-0.4) square([POCK_W-0.4, POCK_D-0.4], center=true); }}
        intersection() {{ translate([0, PIV_Y, PIV_Z]) rotate([-{t},0,0]) translate([0,-PIV_LY,-PIV_LZ]) _cam(); _tray_at({t}); }}"""))
    line += f"   tray-into-camera: {vol2:6.1f} mm3"
    if n2: ok = False; line += "  FAIL"
    else: line += "  ok"
    # 3. legs vs the camera at this step — must be EMPTY
    vol3, n3, _ = volume(render(HEAD + f"""
        module _cam() {{ translate([0,0,TRAY_T+0.2]) linear_extrude(CAM_D-0.4) square([POCK_W-0.4, POCK_D-0.4], center=true); }}
        intersection() {{ translate([0, PIV_Y, PIV_Z]) rotate([-{t},0,0]) translate([0,-PIV_LY,-PIV_LZ]) _cam(); _arm(); }}"""))
    line += f"   legs-into-camera: {vol3:6.1f} mm3"
    if n3: ok = False; line += "  FAIL"
    else: line += "  ok"
    # 4. the index pin passes through leg AND yoke at this step — a 1.75 pin at
    #    the leg's hole for t must not hit material of either part
    vol4, n4, _ = volume(render(HEAD + f"""
        p = idx_at({t});
        module _pin() {{ translate([-100, p[0], p[1]]) rotate([0,90,0]) cylinder(d = 1.75, h = 200, $fn = 24); }}
        intersection() {{ _pin(); union() {{ _arm(); _tray_at({t}); }} }}"""))
    line += f"   pin blocked: {vol4:6.1f} mm3"
    if n4: ok = False; line += "  FAIL"
    else: line += "  ok"
    # 5. ...and there must be MATERIAL around that pin in BOTH parts. Without
    #    this, a hole that has drifted off the bar into thin air passes as
    #    "unblocked" — which is exactly how three of four holes shipped missing.
    vol5, n5, _ = volume(render(HEAD + f"""
        p = idx_at({t});
        module _probe() {{ translate([-100, p[0], p[1]]) rotate([0,90,0]) cylinder(d = 4.5, h = 200, $fn = 24); }}
        intersection() {{ _probe(); union() {{ _legs(); translate([0, PIV_Y, PIV_Z]) rotate([-{t},0,0]) translate([0,-PIV_LY,-PIV_LZ]) _tray_yoked_solid(); }} }}"""))
    # A 4.5 mm probe through two 10 mm legs and two 4 mm yokes is ~450 mm3 of
    # material; air is 0. 150 separates them with room, and does not depend on
    # reading ARM_LEG, which is an expression in the .scad rather than a literal.
    expect = 150.0
    line += f"   hole in material: {vol5:6.1f} mm3"
    if vol5 < expect: ok = False; line += f"  FAIL (< {expect:.0f})"
    else: line += "  ok"
    print(line)

# 5. the tray part has nothing below its own floor (prints floor-down, no support)
_, _, _ = None, None, None
out = render(HEAD + "_tray_yoked();")
fh = open(out,"rb"); fh.read(80); n = struct.unpack("<I", fh.read(4))[0]
zmin = 1e9
for _ in range(n):
    q = struct.unpack("<12f", fh.read(50)[:48])[3:]
    zmin = min(zmin, q[2], q[5], q[8])
print(f"\ntray part lowest point z = {zmin:+.2f}  (floor is 0)", "ok" if zmin >= -0.01 else "FAIL — hangs below its floor")
if zmin < -0.01: ok = False

print("\n" + ("PASS" if ok else "FAIL"))
sys.exit(0 if ok else 1)
