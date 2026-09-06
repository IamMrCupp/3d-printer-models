#!/usr/bin/env python3
"""The arm must stay OUT of the camera's seated volume.

The arm lands on the tray's inboard edge and buries its end in the tray's
thickness. If it ever rises above the floor's top face inside the pocket, the
camera sits on the arm instead of the floor and the fit is gone.

This was briefly "solved" by splitting the arm into two legs straddling the plug
notch. That cost 44% of the section and snapped off the bottom plate during
support removal. The collision it was avoiding never existed — the notch is
subtracted inside _tray(), before the arm is unioned. So the arm stays whole and
this check holds the line instead.

Method: intersect the arm with the camera's seated volume in OpenSCAD and
measure what comes back. The probe is INSET 0.2 mm on every face — a probe
sharing a plane with the model returns a zero-volume shell that reads as a
collision.
"""
import os, struct, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))

PROBE = """include <%s/thermal_cam_mount_common.scad>
$fn = 64;
INSET = 0.2;
intersection() {
    _arm();
    translate([0, cr_y, cr_z]) rotate([-TRAY_TILT, 0, 0])
        translate([0, 0, TRAY_T + INSET])
            linear_extrude(CAM_D - 2*INSET)
                square([POCK_W - 2*INSET, POCK_D - 2*INSET], center = true);
}
""" % HERE


def render(src):
    f = tempfile.NamedTemporaryFile(suffix=".scad", delete=False, mode="w")
    f.write(src)
    f.close()
    out = f.name.replace(".scad", ".stl")
    r = subprocess.run(["openscad", "-o", out, "--export-format", "binstl", f.name],
                       capture_output=True, text=True)
    return out, r.stderr


def mesh_volume(path):
    """Signed volume via the divergence theorem; 0 triangles means empty."""
    if not os.path.exists(path) or os.path.getsize(path) < 84:
        return 0.0, 0
    fh = open(path, "rb")
    fh.read(80)
    n = struct.unpack("<I", fh.read(4))[0]
    vol = 0.0
    lo = [9e9] * 3
    hi = [-9e9] * 3
    for _ in range(n):
        v = struct.unpack("<12f", fh.read(50)[:48])[3:]
        a, b, c = v[0:3], v[3:6], v[6:9]
        vol += (a[0] * (b[1] * c[2] - b[2] * c[1])
                - a[1] * (b[0] * c[2] - b[2] * c[0])
                + a[2] * (b[0] * c[1] - b[1] * c[0])) / 6.0
        for p in (a, b, c):
            for k in range(3):
                lo[k] = min(lo[k], p[k])
                hi[k] = max(hi[k], p[k])
    return abs(vol), n, [hi[k] - lo[k] for k in range(3)] if n else None


def main():
    out, err = render(PROBE)
    res = mesh_volume(out)
    vol, ntri = res[0], res[1]
    print("probe: arm  X  camera seated volume, inset 0.2 mm on every face")
    if ntri == 0:
        print("intersection is EMPTY (0 triangles)")
        print("PASS  the arm stays clear of the camera")
        return 0
    ext = res[2]
    print("intersection: %.1f mm3 over %d triangles, bbox %.2f x %.2f x %.2f"
          % (vol, ntri, ext[0], ext[1], ext[2]))
    if min(ext) < 1e-3:
        print("NOTE  one axis has zero extent - this is a coincident-face shell,")
        print("      not a real collision. Increase INSET and re-run.")
    print("FAIL  the arm intrudes into the camera pocket")
    return 1


if __name__ == "__main__":
    sys.exit(main())
