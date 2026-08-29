// scope_seat_coupon — PRINT THIS BEFORE THE PLATE, alongside scope_wrap_coupon.
//
// One END CELL of the plate plus the skirt's end wall — the exact region where
// v2.0.0 failed. That version ran the skirt straight through these sockets
// (448 mm3 of solid bar per cell) and nothing seated.
//
// `tools/check_sockets.py` now catches that in software. This catches what
// software cannot: whether a real Gridfinity bin actually drops in and holds.
// A socket can be geometrically clear and still be the wrong shape, or print
// tight, and no mesh check will ever say so.
//
// It is an intersection() against the real scope_wipe_plate(), not a
// re-derivation, so it cannot drift from the part it stands in for.
//
// HOW TO USE
//   1. Print flat, grid face DOWN, no supports — same as the plate.
//   2. Drop any Gridfinity bin into the cell. It should seat fully, sit flat,
//      and not rock.
//        seats and sits flat        -> print the plate
//        bottoms out proud          -> something is in the socket; run
//                                      tools/check_sockets.py before reprinting
//        seats but rocks            -> the end wall is standing proud of the grid
//   3. The skirt stub on the end is there so you can also see that it stops at
//      the plate's underside and not above it.
//
// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Aaron Cupp
include <../scope_plate_common.scad>
$fn = 96;

// The far end cell of the middle column, x 63..105, plus the skirt end wall.
// 22 in Y, not 21, so the cut misses the exact cell boundary where two socket
// openings meet at the top face — a cut plane tangent to that line is the same
// hazard the pole slot has to dodge.
intersection() {
    scope_wipe_plate();
    translate([GRID_NX*GF/2 - GF, -22, -SKIRT_DEPTH - 1])
        cube([GF + 1, 44, SKIRT_DEPTH + BP_H + 2]);
}
