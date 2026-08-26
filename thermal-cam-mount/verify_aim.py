#!/usr/bin/env python3
"""Assert the thermal cam's lens points DOWN and INWARD, and that its sight
line clears the top plate's front-top corner. Run before any print."""
import math, sys

CAM_ANGLE=30; CAM_D=14; CAM_H=35; CAM_CLR=0.6; WALL=3
TAB_FB=32.51; TAB_T=26.42; FIT=0.3; PLATE_T=5
ARM_FWD=19.5; ARM_UP=0
TILT=90-CAM_ANGLE

half=TAB_T/2+FIT/2; y_front=TAB_FB/2
top_z1=half+PLATE_T; cr_y=y_front+ARM_FWD; cr_z=top_z1+ARM_UP
th=math.radians(TILT); c,s=math.cos(th),math.sin(th)
rot=lambda y,z:(y*c-z*s, y*s+z*c)

# cam sits in the cavity: local y WALL..WALL+CAM_D+CAM_CLR, z LIP..LIP+CAM_H
# lens = the OPEN low-y face; screen = against the back wall at high y
lens_y=WALL; screen_y=WALL+CAM_D+CAM_CLR; mid_z=4.5+CAM_H/2
(ly,lz)=rot(lens_y,mid_z); (sy,sz)=rot(screen_y,mid_z)
ly+=cr_y; lz+=cr_z; sy+=cr_y; sz+=cr_z
n=(ly-sy, lz-sz); m=math.hypot(*n); n=(n[0]/m, n[1]/m)
ang=math.degrees(math.atan2(-n[0], -n[1]))   # from straight-down, +ve = inward

ok=True
print(f"lens centre        y={ly:7.2f}  z={lz:7.2f}")
print(f"lens vector        dY={n[0]:+.3f} dZ={n[1]:+.3f}  -> {abs(ang):.1f} deg from vertical, "
      f"{'INWARD' if n[0]<0 else 'OUTWARD'}, {'DOWN' if n[1]<0 else 'UP'}")

if n[1] >= 0: print("  FAIL lens points UP"); ok=False
if n[0] >= 0: print("  FAIL lens points away from the optical axis"); ok=False

# every ray from A..A+halfFOV must pass forward/above the plate's front-top corner
corner=(y_front, top_z1)
print(f"\nplate front-top corner  y={corner[0]:.2f}  z={corner[1]:.2f}")
for a in (abs(ang)-21, abs(ang), abs(ang)+21):     # 42 deg vertical FOV
    if a<=0: continue
    dz = (ly-corner[0])/math.tan(math.radians(a))
    z_at = lz - dz
    clr = z_at - corner[1]
    flag = "ok " if clr>0 else "FAIL"
    if clr<=0: ok=False
    print(f"  ray {a:5.1f} deg -> crosses corner plane at z={z_at:7.2f}  clearance {clr:+7.2f}  {flag}")

# nothing may sit below the top plate's underside except the clamp itself
lo = min(rot(y,z)[1] for y in (0, CAM_D+CAM_CLR+2*WALL) for z in (0,19)) + cr_z
print(f"\nlowest cradle point  z={lo:.2f}   (top plate underside z={half:.2f})")
if lo < half: print("  FAIL cradle dips below the tab's top face"); ok=False
else: print("  ok  cradle stays above the tab plane -> out of the working volume")

print("\n"+("PASS" if ok else "FAIL")); sys.exit(0 if ok else 1)
