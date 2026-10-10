// bin_chip_vacuum — 1×1 cup that stands the handheld chip-puller vacuum upright,
// bottom end down.
//
// MEASURED (survey/MEASUREMENTS.md, user's calipers, 2026-10-09):
//   34 × 24 × 170 mm with its tip on; rectangular, slightly rounded corners;
//   the bottom end is the
//   largest part and goes into the cup. The charge port is on that bottom face
//   and it will not charge in the holder, so the floor is closed.
//   The spare tip and suction cups live in a bin the user already has.
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

/* [Cup] */
CLR      = 0.6;    // on each dimension — this design's choice
CAPTURE  = 45;     // [30:1:80] how much of the body sits in the cup
FLOOR    = 1.4;

POCKET_W = VAC_W + CLR;
POCKET_D = VAC_D + CLR;
H = BIN_BASE_H + FLOOR + CAPTURE;

assert(POCKET_W < GF - 0.5 - 2*1.2, "Pocket breaks the 1×1 cell's walls.");
echo(str("cup ", GF - 0.5, " square × ", H, " tall; pocket ", POCKET_W, " × ", POCKET_D, " × ", CAPTURE,
         "; walls ", (GF - 0.5 - POCKET_W)/2, " / ", (GF - 0.5 - POCKET_D)/2));

difference() {
    bin_blank(1, 1, H);
    translate([-POCKET_W/2, -POCKET_D/2, BIN_BASE_H + FLOOR]) cube([POCKET_W, POCKET_D, CAPTURE + 1]);
}
