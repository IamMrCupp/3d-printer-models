// bin_chip_vacuum — 1×2: one cell stands the handheld chip-puller vacuum upright,
// bottom end down; the other is an open well for its spare tip and suction cups,
// so the tool and its bits lift out together.
//
// MEASURED (survey/MEASUREMENTS.md, user's calipers, 2026-10-09):
//   34 × 24 × 170 mm with its tip on; rectangular, slightly rounded corners;
//   the bottom end is the
//   largest part and goes into the cup. The charge port is on that bottom face
//   and it will not charge in the holder, so the floor is closed.
//   Its spare tip and suction cups go in the open well (user, 2026-10-09 — the
//   well needs no measurements: it is a plain compartment, not a fit).
//
// A SQUARE-CORNERED POCKET FOR A ROUND-CORNERED BODY. The vacuum is rectangular
// with slightly rounded corners, so a pocket drawn with square corners leaves its
// corners clear and the four flats do the locating — the retain-on-the-flats
// rule. (A sharp-cornered body would have needed relief cuts; this one doesn't.)
//
// CAPTURE IS A COMFORT CHOICE, NOT A DERIVED NUMBER, the same call as the rotary
// tool cup: the bin latches into the grid, so nothing tips. 45 mm of a 170 mm
// body with 0.6 mm of clearance leans it under a degree and leaves plenty to grab.
//
// PRINT: as emitted, feet down. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp

include <../lib/gridfinity.scad>

/* [Vacuum — measured] */
VAC_W = 34.0;      // bottom end, the largest part
VAC_D = 24.0;

/* [Bin] */
NX = 1; NY = 2;
CLR      = 0.6;    // on each dimension — this design's choice
CAPTURE  = 45;     // [30:1:80] how much of the body sits in the cup
FLOOR    = 1.4;
WALL     = 1.2;
DIVIDER  = 3.0;    // between the vacuum pocket and the well
WELL_DEPTH = 30;   // [15:1:45] shallower than the pocket so small parts are easy to pick out
WELL_R   = 3;      // well corner radius

POCKET_W = VAC_W + CLR;            // along X, the 1-cell width
POCKET_D = VAC_D + CLR;            // along Y
H   = BIN_BASE_H + FLOOR + CAPTURE;
W   = NX*GF - 0.5;  D = NY*GF - 0.5;
POCKET_Y = -GF/2;                   // centred in the -Y cell
WELL_Y0  = POCKET_Y + POCKET_D/2 + DIVIDER;
WELL_Y1  = D/2 - WALL;
WELL_W   = W - 2*WALL;

assert(POCKET_W < W - 2*WALL, "Pocket breaks the side walls.");
assert(POCKET_Y - POCKET_D/2 > -D/2 + WALL, "Pocket breaks the end wall.");
assert(WELL_Y1 - WELL_Y0 > 25, "Well too short to be useful.");
echo(str("bin ", W, " × ", D, " × ", H, "; pocket ", POCKET_W, " × ", POCKET_D, " × ", CAPTURE,
         "; well ", WELL_W, " × ", WELL_Y1 - WELL_Y0, " × ", WELL_DEPTH));

difference() {
    bin_blank(NX, NY, H);
    translate([-POCKET_W/2, POCKET_Y - POCKET_D/2, BIN_BASE_H + FLOOR]) cube([POCKET_W, POCKET_D, CAPTURE + 1]);
    translate([0, (WELL_Y0 + WELL_Y1)/2, H - WELL_DEPTH])
        linear_extrude(WELL_DEPTH + 1) offset(r = WELL_R, $fn = 32) offset(delta = -WELL_R)
            square([WELL_W, WELL_Y1 - WELL_Y0], center = true);
}
