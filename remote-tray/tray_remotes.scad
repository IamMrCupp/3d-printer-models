// tray_remotes — 6×1 tray, one sized slot per remote, standing on end.
//
// HOW YOU USE IT:
//   Each remote stands upright in its own slot, cut to that remote's width and
//   thickness. You grab the one you want by the top and lift it straight out.
//   Nothing has to be moved to reach anything else, and a remote can only go back
//   in its own slot.
//
// WHY SLOTS AND NOT ONE BIN: five remotes in a common well fall over each other
// and you dig. The narrowest here is 8 mm thick and the widest 35 — in a shared
// well the thin ones just lie down.
//
// SLOTS ARE FRONT-ALIGNED. All the faces present at one line, so the row reads as
// a row. Back-aligning would stagger the fronts and bury the thin ones.
//
// WHY 6×1: the slots total 226 mm. With clearance and walls that is 243, and a
// 6×1 gives 249.1 of interior. A 7×1 would be 293.5 and does NOT fit the 270 bed.
// Walls are 2 mm rather than the usual 3 for the same reason — at 3 mm it needs
// 249.0 against 249.1 available, which is not a fit, it is a coincidence.
//
// PRINT: as emitted, feet down. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../lib/gridfinity.scad>

// [name, width, thickness] — measured 2026-08-20. Lengths run 90 to ~180 mm.
REMOTES = [
    ["Roku",       42, 21],
    ["Insignia TV",50, 20],
    ["LG 4K TV",   45, 35],
    ["Scope cam",  41, 10],
    ["Fume ext",   48,  8],
];

NX      = 6;
CAPTURE = 50;    // [30:1:80] slot depth, and a compromise between two ends of the
                 //   range. The shortest remote is 90, so 50 holds over half of it
                 //   and still leaves 40 to grab; go deeper and the short ones get
                 //   hard to pinch out. The longest is ~180 and stands 130 proud —
                 //   fine, because the slot grips its full width and thickness like
                 //   a book in a shelf. A round bore could not do that.
CLR     = 1.0;   // [0.5:0.1:2] per dimension
DIV     = 2.0;   // [1.6:0.2:4] wall between slots — see the 6×1 note above
WALL    = 1.2;
FLOOR   = 1.4;

W = NX*GF - 0.5; D = 1*GF - 0.5;
IW = W - 2*WALL; ID = D - 2*WALL;
Z0 = BIN_BASE_H + FLOOR;
H  = Z0 + CAPTURE;

SUM   = [for (r = REMOTES) r[1] + CLR];
TOTAL = len(REMOTES) == 0 ? 0
      : SUM[0] + (len(REMOTES) > 1 ? add(SUM, 1) : 0);
function add(v, i) = i >= len(v) ? 0 : v[i] + add(v, i + 1);
NEED  = TOTAL + (len(REMOTES) - 1)*DIV;
MARGIN = (IW - NEED) / 2;

assert(MARGIN >= 2, str("Slots need ", NEED, " of ", IW, " — only ", MARGIN,
                        " mm margin each end. Widen the tray or thin DIV."));
for (r = REMOTES) assert(r[2] + CLR <= ID - 2, str(r[0], " is too thick for a 1-cell depth."));
echo(str("slots need ", NEED, " of ", IW, " interior; ", MARGIN, " mm margin each end"));

difference() {
    bin_blank(NX, 1, H);
    for (i = [0 : len(REMOTES) - 1]) {
        wsum = i == 0 ? 0 : add([for (k = [0 : i-1]) SUM[k] + DIV], 0);
        x0   = -IW/2 + MARGIN + wsum;
        pw   = REMOTES[i][1] + CLR;
        pd   = REMOTES[i][2] + CLR;
        translate([x0, -ID/2, Z0]) cube([pw, pd, CAPTURE + 0.1]);
    }
}
