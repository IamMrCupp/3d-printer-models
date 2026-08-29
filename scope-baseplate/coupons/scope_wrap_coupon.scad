// scope_wrap_coupon — PRINT THIS BEFORE THE PLATE.
//
// A 22 mm band sliced off the FAR end of the real plate: both side walls at
// their true spacing, the far end wall, both corners, and a slice of grid
// holding them together. Everything the full plate risks, at a fraction of it.
//
// It is an intersection() against the actual scope_wipe_plate(), not a
// re-derivation. If the plate changes, this changes with it — a coupon that
// restates the geometry can pass while the part it is standing in for fails.
//
// WHAT IT TESTS
//   - FIT on the binding axis. The bore is 131.38 over a 130.18 plateau, so
//     0.6 mm a side. That is the dimension PETG shrink eats; one wall tells you
//     nothing, two walls at true spacing tell you everything.
//   - CORNER. 14, gauged not calipered. If the flats seat but the corners hang
//     up, the radius is wrong, not the width.
//   - STEP_H. The wall drops 12 mm. If it bottoms out before the plate is flat
//     on the plateau, the step is shallower than 17.76.
//
// WHAT IT DOES NOT TEST
//   The pole slot, or the assumption that the boss is centred across the width.
//   Those live at the other end.
//
// HOW TO USE
//   1. Print flat, grid down, no supports. Same material as the plate — PETG
//      shrink is the thing being measured, so PLA would lie.
//   2. Slide it onto the FAR end of the plateau, walls straddling the sides.
//   3. Read it:
//        drops on, sits flat, no rock            -> FIT and CORNER are right
//        binds on the flats                      -> FIT too small, raise it
//        flats seat, corners hang up             -> CORNER too big, drop it
//        rocks, or the wall bottoms before flat  -> STEP_H is less than 17.76
//        loose enough to rattle                  -> FIT too large, drop it
//   4. Tell me which, and the number changes in one place.
//
// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Aaron Cupp
include <../scope_plate_common.scad>
$fn = 96;

// 84 is a cell CENTRE, not a cell boundary. Slicing on a boundary puts the cut
// plane tangent to where two socket openings meet at the top face — the same
// tangency that has to be dodged for the pole slot.
BAND_X = 84;

intersection() {
    scope_wipe_plate();
    translate([BAND_X, -SKIRT_OUT_W, -SKIRT_DEPTH - 1])
        cube([GRID_NX*GF/2 - BAND_X + 1, 2*SKIRT_OUT_W, SKIRT_DEPTH + BP_H + 2]);
}
