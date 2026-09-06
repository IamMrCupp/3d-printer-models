#!/usr/bin/env python3
"""The plug and cord must have a clear channel out of the tray.

The plug leaves the camera at the tray's INBOARD edge, passes through the notch
in the tray floor, and travels up between the arm's two legs into open air. If
anything closes that channel the camera cannot be fitted at all.

This check exists because the arm was once "fixed" by merging its two legs back
into a single web to cure a breakage. That closed the channel completely, and
nothing in the toolchain noticed.
"""
import math, os, struct, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = """include <%s/thermal_cam_mount_common.scad>
$fn = 64;
mount_bottom();
""" % HERE

TILT, CR_Y = 14.0, 42.26
NOTCH_TRAY_Y = (-24.0, -18.0)   # tray-frame Y band the notch spans
NEED_W = 12.0                   # channel must be at least this wide in X


def render():
    f = tempfile.NamedTemporaryFile(suffix=".scad", delete=False, mode="w")
    f.write(SRC); f.close()
    out = f.name.replace(".scad", ".stl")
    subprocess.run(["openscad", "-o", out, "--export-format", "binstl", f.name],
                   capture_output=True, check=True)
    return out


def tris(path):
    fh = open(path, "rb"); fh.read(80)
    n = struct.unpack("<I", fh.read(4))[0]
    for _ in range(n):
        v = struct.unpack("<12f", fh.read(50)[:48])[3:]
        yield (v[0:3], v[3:6], v[6:9])


def blocked_above(T, x, y, z0):
    """Is there material on a +Z ray from (x, y, z0)?"""
    for (a, b, c) in T:
        d1 = (b[0]-a[0])*(y-a[1]) - (b[1]-a[1])*(x-a[0])
        d2 = (c[0]-b[0])*(y-b[1]) - (c[1]-b[1])*(x-b[0])
        d3 = (a[0]-c[0])*(y-c[1]) - (a[1]-c[1])*(x-c[0])
        if (d1 >= 0 and d2 >= 0 and d3 >= 0) or (d1 <= 0 and d2 <= 0 and d3 <= 0):
            A = (b[1]-a[1])*(c[2]-a[2]) - (b[2]-a[2])*(c[1]-a[1])
            B = (b[2]-a[2])*(c[0]-a[0]) - (b[0]-a[0])*(c[2]-a[2])
            C = (b[0]-a[0])*(c[1]-a[1]) - (b[1]-a[1])*(c[0]-a[0])
            if abs(C) > 1e-9:
                zi = a[2] + (-A*(x-a[0]) - B*(y-a[1]))/C
                if zi > z0 + 0.05:
                    return True
    return False


def main():
    T = list(tris(render()))
    zmin = min(q[2] for t in T for q in t)
    a = math.radians(-TILT)
    open_cols = []
    for i in range(-16, 17):
        x = i * 0.5
        clear = True
        for ty in (NOTCH_TRAY_Y[0], (sum(NOTCH_TRAY_Y))/2, NOTCH_TRAY_Y[1]):
            gy = CR_Y + ty*math.cos(a)
            if blocked_above(T, x, gy, zmin - 1):
                clear = False
                break
        if clear:
            open_cols.append(x)
    if not open_cols:
        print("FAIL  no clear column anywhere across the notch - the channel is CLOSED")
        return 1
    lo, hi = min(open_cols), max(open_cols)
    width = hi - lo
    print("clear channel above the plug notch: x %.1f .. %.1f  (%.1f mm wide)" % (lo, hi, width))
    if width < NEED_W:
        print("FAIL  channel is narrower than the %.1f mm the plug needs" % NEED_W)
        return 1
    print("PASS  the plug and cord have a way out")
    return 0


if __name__ == "__main__":
    sys.exit(main())
