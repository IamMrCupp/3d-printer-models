// peg_fit_coupon — print first, IN TPU 95A. Finds the peg size that presses into
// the helping-hands plate's foot holes and stays, before the feet are made.
//
// The hole is 3.83 mm (calipered, survey/MEASUREMENTS.md, 2026-10-26). TPU is soft,
// so the right peg is a little OVER the hole — it squeezes in and grips. How much
// over depends on how this printer lays down TPU, which is what this answers.
//
//   4 PEGS   3.8 / 3.9 / 4.0 / 4.1 mm, 3 mm long, each on its own small pad.
//            Raised dots on each pad count 1-4, smallest = 1 dot.
//   Want:    pushes in with a firm thumb press and doesn't fall out when the
//            plate is lifted. Too easy → next size up; won't go in → next down.
//
// PRINT: flat as emitted, pads down, pegs up, in TPU. No supports. ~2 g.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp

PEGS   = [3.8, 3.9, 4.0, 4.1];
PEG_L  = 3.0;     // short enough for a blind hole of unknown depth
PEG_CHAM = 0.4;   // lead-in at the tip
PAD_D  = 12;
PAD_T  = 2;
PITCH  = 16;
DOT_D  = 1.6; DOT_H = 0.6;
$fn = 64;

for (i = [0:len(PEGS)-1]) translate([i*PITCH, 0, 0]) {
    cylinder(d = PAD_D, h = PAD_T);
    // peg: a PARTIAL-area join onto the pad, so it overlaps rather than butts
    translate([0, 0, PAD_T - 0.4]) {
        cylinder(d = PEGS[i], h = PEG_L - PEG_CHAM + 0.4);
        translate([0, 0, PEG_L - PEG_CHAM + 0.4 - 0.01])
            cylinder(d1 = PEGS[i], d2 = PEGS[i] - 2*PEG_CHAM, h = PEG_CHAM);
    }
    // count dots, on the pad around the peg
    for (k = [0:i]) rotate([0, 0, -90 + (k - i/2) * 28])
        translate([4.3, 0, PAD_T - 0.01]) cylinder(d = DOT_D, h = DOT_H + 0.01, $fn = 16);
    // a thin bridge to the next pad so they print and stay as one strip
    if (i < len(PEGS)-1) translate([PAD_D/2 - 1, -1.5, 0]) cube([PITCH - PAD_D + 2, 3, 1]);
}
