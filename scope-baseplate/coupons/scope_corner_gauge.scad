// scope_corner_gauge.scad — corner-radius gauge for the microscope boom's
// weighted-base platform. PRINT THIS BEFORE THE PLATE.
//
// `CORNER` in scope_plate_common.scad is the one dimension on that model that
// was never measured — it's flagged `⚠ estimate` at 12 mm. Everything else came
// off calipers. That matters more than it sounds: the skirt is a slip fit at
// FIT = 0.4 mm around a 131.84 × 130.54 mm platform, and a corner radius that's
// wrong by a couple of millimetres is exactly what stops a close-fitting skirt
// from seating — the flats look fine and it hangs up on the corners.
//
// Calipers can't read a fillet. This can.
//
// EIGHT female corners, 6 → 20 mm in 2 mm steps. Each is an L with a concave
// 90° corner of a known radius and ~18 mm of straight leg either side to
// register against the platform's flats.
//
// HOW TO USE
//   1. Print flat. Any material — this is a measuring tool, not a part.
//      Fast/draft is fine; corner accuracy comes from the arc, not the finish.
//   2. Count the notches on each gauge's face: 1 = 6 mm, then +2 mm per notch
//      (2 = 8, 3 = 10, 4 = 12 … 8 = 20 mm).
//   3. Press each one onto a corner of the platform. Both legs flat against the
//      platform's straight edges.
//   4. Look at the arc against the corner, ideally with a light behind it:
//        - gap in the MIDDLE of the arc, legs touching  → gauge radius too BIG
//        - gap at the LEG ENDS, arc touching            → gauge radius too SMALL
//        - contact all the way round                    → that's your radius
//   5. Tell me the notch count and I'll set `CORNER` and re-cut the plate.
//
// If it lands between two gauges, say which two — I'll set the midpoint, or add
// a fine gauge at 1 mm steps across that pair.
//
// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Aaron Cupp

/* [Gauge set] */
// Candidate radii, smallest first. Notch count = position in this list.
RADII = [6, 8, 10, 12, 14, 16, 18, 20];

/* [Geometry] */
LEG  = 45.0;  // [30:1:70] mm overall size — must exceed ARM + max radius + a
              //   usable straight run, or the biggest gauge has no legs to
              //   register with. At LEG 45 / ARM 7, the 20 mm gauge still keeps
              //   18 mm of flat either side.
ARM  = 7.0;   // [4:0.5:12] mm arm thickness
THK  = 3.0;   // [2:0.5:6] mm plate thickness

/* [Marking] */
NOTCH = 1.2;  // [0.8:0.1:2.0] mm tally notch size
N_GAP = 1.6;  // [1:0.1:3] mm gap between notches

/* [Layout] */
COLS = 4;     // [1:8] gauges per row on the bed
GAP  = 4.0;   // [2:1:10] mm between gauges

/* [Quality] */
$fn = 96;     // [48:8:160] the arc IS the measurement — keep this high

// One L-shaped gauge with a concave corner of radius r, tallied with n notches.
//
// The cut square is deliberately oversized (3*LEG): `offset(-r)` on a square
// smaller than 2*r collapses to nothing, which would silently produce a gauge
// with no notch cut at all for the larger radii.
module corner_gauge(r, n) {
    difference() {
        linear_extrude(THK)
            difference() {
                square([LEG, LEG]);
                translate([ARM, ARM])
                    offset(r) offset(-r) square([3*LEG, 3*LEG]);
            }
        // tally notches, sunk into the top face of the long arm
        for (i = [0 : n-1])
            translate([LEG - 5 - i*(NOTCH + N_GAP), (ARM - NOTCH)/2, THK - 0.8])
                cube([NOTCH, NOTCH, 1.0]);
    }
}

for (i = [0 : len(RADII) - 1])
    translate([(i % COLS) * (LEG + GAP), floor(i / COLS) * (LEG + GAP), 0])
        corner_gauge(RADII[i], i + 1);
