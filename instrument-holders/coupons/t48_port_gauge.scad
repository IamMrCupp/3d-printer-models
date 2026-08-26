// t48_port_gauge — PRINT THIS BEFORE REPRINTING bin_t48. ~5 g, minutes.
//
// Answers BOTH open numbers on this model in one reading:
//
//   1. T48_NOTCH_X — how far the USB port sits off the T48's centreline. The
//      printed bin cut its slot dead centre and drags the lead against the wall.
//   2. NOTCH_W     — the overmould width, which has never been measured. The
//      source default of 10 is a guess (see the warning on NOTCH_W).
//
// Read the port's LEFT and RIGHT edges against the scale: the midpoint is
// T48_NOTCH_X, the span is the overmould width. One part, two numbers, no
// calipers needed in an awkward corner.
//
// HOW TO USE
//   1. Press the gauge flat against the T48's rear face (the end the USB is on),
//      with the two end tabs hugging the device's sides. The tabs register on
//      the measured 66 mm width, so the gauge self-centres — 0 on the scale IS
//      the instrument's centreline.
//   2. Sight through the window at the USB opening.
//   3. Read both edges of the opening. Ticks are 2.5 mm, tall ticks 10 mm,
//      numbered every 10 mm. Positive is toward the `IC`-arrow side.
//   4. Report both numbers. Do NOT round to a "nice" value — the whole reason
//      this model is being reprinted is a number that looked plausible.
//
// WHY A GAUGE AND NOT A GUESS: a photo scales to ~11 mm and "about 1.25 cutout
// widths" is ~12.5, but that second figure is anchored to NOTCH_W = 10, which is
// itself unmeasured — if the overmould is really 12, the same eyeball becomes
// 15 mm while the port has not moved. Reprinting bin_t48 is 86 g. This is 5 g.
//
// NOTE ON POCKET SLOP: the T48 is 66 mm in an ~81 mm interior, so it can sit
// ±7.5 mm either way inside the bin. That is MORE than the offset being argued
// about. This gauge measures the port against the INSTRUMENT's centreline; if
// the T48 does not sit centred in its pocket, the slot wants moving by the same
// amount again, or the pocket wants locating ribs. Worth a look while it's out.
//
// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Aaron Cupp

use <../../lib/label.scad>

/* [Instrument] */
T48_W = 66.0;   // measured 2026-08-16; the gauge self-centres on this

/* [Gauge] */
THK    = 3.0;   // [2:0.5:5] plate thickness
DEPTH  = 30.0;  // [15:1:40] plate height — must leave a band above the window
                //   wide enough for BOTH the ticks and the numerals; asserted below
TAB    = 3.0;   // [2:0.5:6] end tab thickness
TAB_D  = 7.0;   // [4:1:12] how far the tabs wrap onto the device's sides
WIN_W  = 46.0;  // [30:1:60] window width — must clear the port and its travel
WIN_H  = 13.0;  // [8:1:20] window height

/* [Scale] */
RANGE  = 25;    // [10:5:30] mm either side of centre
STEP   = 2.5;   // [1:0.5:5] tick spacing
TICK_S = 2.0;   // short tick length
TICK_L = 4.0;   // tall tick, every 10 mm
TICK_W = 0.6;   // tick width
ENGRAVE = 0.6;  // tick / numeral depth
TEXT   = 3.2;

$fn = 32;

PLATE_W = T48_W + 2*TAB;

// Window sits low so the band above it carries the scale. Everything below is
// derived from these two, so moving the window moves the scale with it.
WIN_TOP = -(DEPTH - WIN_H)/2 - 2;     // a little below centre
WIN_BOT = WIN_TOP - WIN_H;
NUM_Y   = WIN_TOP + TICK_L + 1.0 + TEXT/2;

// The numerals were once placed off the top edge of the plate entirely and cut
// into empty space — the render looked fine because a difference() against
// nothing is silent. Assert the band instead of trusting the arithmetic.
assert(NUM_Y + TEXT/2 <= -0.5,
       str("Numerals run off the plate: they reach y=", NUM_Y + TEXT/2,
           " and the top edge is 0. Increase DEPTH or shrink TICK_L/TEXT."));
assert(WIN_BOT > -DEPTH + 2, "Window breaks through the bottom edge of the plate.");

difference() {
    union() {
        translate([-PLATE_W/2, -DEPTH, 0]) cube([PLATE_W, DEPTH, THK]);
        // End tabs wrap onto the instrument's sides and set the centreline.
        for (s = [-1, 1])
            translate([s*(T48_W/2) - (s < 0 ? TAB : 0), -DEPTH, 0])
                cube([TAB, DEPTH, THK + TAB_D]);
    }

    // Sight window
    translate([-WIN_W/2, WIN_BOT, -1]) cube([WIN_W, WIN_H, THK + 2]);

    // Scale along the window's upper edge
    for (i = [-RANGE/STEP : RANGE/STEP]) {
        x = i * STEP;
        tall = abs(x % 10) < 0.01;
        translate([x - TICK_W/2, WIN_TOP, THK - ENGRAVE])
            cube([TICK_W, tall ? TICK_L : TICK_S, ENGRAVE + 1]);
    }
    for (n = [-20, -10, 0, 10, 20])
        translate([n, NUM_Y, THK])
            label_pocket(str(n), size = TEXT, depth = ENGRAVE);
}
