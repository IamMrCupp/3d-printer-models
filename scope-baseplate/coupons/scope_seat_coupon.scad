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

// The far end cell of the middle column plus the skirt end wall.
//
// THE Y HALF-WIDTH IS 25, AND THE NUMBER MATTERS. The first version used 22,
// which is exactly SLOT_W/2 — the pole slot's own wall plane, at the far end of
// the plate. Cutting on that plane produced a 9.03e-04 mm sliver triangle on
// OpenSCAD 2021.01. It rendered clean on 2026.06, which is how it reached CI.
//
// Swept on the CI toolchain: 22 fails at every X offset tried; 19, 23 and 25 all
// pass. 25 sits clear of both hazards — the socket boundary at 21 and the slot
// wall at 22.
//
// X is held 2 mm into row 4 for the same reason, off the row 4 / row 5 boundary.
intersection() {
    scope_wipe_plate();
    translate([GRID_NX*GF/2 - GF - 2, -25, -SKIRT_DEPTH - 1])
        cube([GF + 3, 50, SKIRT_DEPTH + BP_H + 2]);
}
