#!/usr/bin/env python3
"""Fail if anything has been unioned INTO a Gridfinity socket.

    tools/check_sockets.py <common.scad> <module()> <nx> <ny>

Point it at the file that DEFINES the module (the model's *_common.scad), not
the part file. A part file calls its module at top level, so including it drops
a whole extra copy of the model into the probe — which lands in BOTH sides of
the comparison and cancels the difference to zero. The first version of this
script did exactly that and reported PASS on the bug it was written for.

Why this exists: scope_wipe_plate v2.0.0 shipped with its click skirt running
through the sockets of the end rows — 448 mm3 of solid bar in every row-5 cell.
It printed. Nothing seated. Every check in the repo passed it:

    watertight, 2-manifold          yes
    bounding box 210 x 136.4 x 17.9 correct
    one connected body              yes
    seats on the plateau            yes, swept the whole insertion path
    corner walls present            yes
    OpenSCAD 2021.01                clean

The per-cell check that WOULD have caught it was run against the model before
the skirt was added and never run again afterwards. That is the whole lesson:
a socket is defined by what ISN'T there, so every check that looks for material
being present is blind to it.

This renders each cell of the model and the same cell of a plain baseplate(nx,ny)
and diffs the volume. Extra material means something is standing in the socket.

LIMIT: it assumes the model's grid is centred on the origin, which is what
baseplate() itself produces. A model that translates its baseplate (e.g.
drybox-splitter-stand does) will compare misaligned cells and report nonsense.
Check the model centres its grid before believing a failure.

SPDX-License-Identifier: MIT
Copyright (c) 2026 Aaron Cupp
"""
import os
import struct
import subprocess
import sys
import tempfile

TOL = 5.0        # mm3 — below this is tessellation noise, not geometry


def vol(path):
    if not os.path.exists(path):
        return 0.0
    f = open(path, "rb")
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


def main():
    if len(sys.argv) != 5:
        sys.exit(__doc__.strip().splitlines()[2].strip())
    scad, mod, nx, ny = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4])
    scad = os.path.abspath(scad)
    d = os.path.dirname(scad)

    # Guard the mistake this script made in its first version: a file with a
    # top-level module call renders a whole extra model into every probe, which
    # cancels out of the diff and turns this check into a rubber stamp.
    for ln in open(scad):
        if ln[:1].isspace():
            continue                       # inside a module body, not top level
        t = ln.split("//")[0].strip()
        if t.endswith(");") and "=" not in t and not t.startswith(
                ("include", "use", "assert", "echo", "module", "function")):
            sys.exit("%s calls %s at top level — point this at the *_common.scad "
                     "that only DEFINES the module, or the probe measures the "
                     "whole model twice and always passes." % (os.path.basename(scad), t))

    probe = os.path.join(d, "_check_sockets_probe.scad")
    open(probe, "w").write(
        "include <%s>\n$fn=96;\nIX=0; IY=0; WHICH=0;\n"
        "module _box() translate([(IX-(%d-1)/2)*GF - GF/2, (IY-(%d-1)/2)*GF - GF/2, 0])\n"
        "    cube([GF, GF, BP_H]);\n"
        "if (WHICH==0) intersection() { %s; _box(); }\n"
        "if (WHICH==1) intersection() { baseplate(%d,%d); _box(); }\n"
        % (os.path.basename(scad), nx, ny, mod, nx, ny))

    bad, dead = [], []
    try:
        with tempfile.TemporaryDirectory() as t:
            print("extra material per socket (mm3) — a socket is a HOLE, so any")
            print("positive number is something standing where a bin's foot goes\n")
            hdr = "        " + "".join("  row%-5d" % (i+1) for i in range(nx))
            print(hdr)
            for iy in range(ny):
                cells = ""
                for ix in range(nx):
                    v = []
                    for w in (0, 1):
                        o = os.path.join(t, "c%d_%d_%d.stl" % (w, ix, iy))
                        subprocess.run(["openscad", "-o", o, "--export-format", "binstl",
                                        "-D", "IX=%d" % ix, "-D", "IY=%d" % iy,
                                        "-D", "WHICH=%d" % w, probe], capture_output=True)
                        v.append(vol(o))
                    dv = v[0] - v[1]
                    if v[0] == 0.0:
                        cells += "     --- "
                        dead.append((ix+1, iy+1))
                    else:
                        cells += " %8.0f" % dv
                        if dv > TOL:
                            bad.append((ix+1, iy+1, dv))
                print("  col%d %s" % (iy+1, cells))
    finally:
        if os.path.exists(probe):
            os.remove(probe)

    if dead:
        print("\n%d cell(s) deliberately absent: %s"
              % (len(dead), ", ".join("row%d col%d" % c for c in dead)))
    if bad:
        print("\nFAIL  %d socket(s) have material in them:" % len(bad))
        for ix, iy, dv in bad:
            print("        row%d col%d  +%.0f mm3" % (ix, iy, dv))
        print("      A bin cannot seat in those. Whatever was unioned onto the")
        print("      baseplate reaches inside the grid footprint above z=0.")
        return 1
    print("\nPASS  every remaining socket is clear")
    return 0


if __name__ == "__main__":
    sys.exit(main())
