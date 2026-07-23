// selftest — instantiates every shared module so CI has real geometry to check.
//
// NOT a model. Nothing here is meant to be printed; it exists because
// tools/render.sh skips module-only sources (a library file emits no top-level
// geometry, so it renders to an empty mesh and is correctly skipped). Without
// this file a library-only change would sail through CI having validated
// nothing at all — the same shape of hole as the stale-artifact false-PASS
// closed in #41 / #43, just arriving from the other direction.
//
// Each instantiation below is a real use of the module with plausible numbers,
// so `validate_stl.py` proves the whole set renders watertight and 2-manifold.
// Add a case here whenever a module joins lib/.

include <gridfinity.scad>
include <vessel.scad>
use <label.scad>

SPACING = 130;

// 1. Collar cup, single bore — sized to a DeoxIT D5 can (54.20 mm measured).
translate([-2 * SPACING, 0, 0]) collar_cup(2, 2, 54.20, 45);

// 2. Collar cup with a cord slot — HARDELL rotary tool (19.66 mm), standing
//    vertical with its barrel-jack lead dropping out the side.
translate([-SPACING, 0, 0]) collar_cup(1, 1, 19.66, 45, cord_w = 6);

// 3. Row of bores — the three aerosols in one block instead of three 2×2 bins.
translate([0, 0, 0]) collar_cup_row(4, 2, [56.0, 54.20, 51.75], 45);

// 4. Lid for a 1×2 bin, print-ready orientation.
translate([SPACING, 0, 0]) lid(1, 2);

// 5. Two-colour label pair: light body with a recessed pocket, and the dark
//    inlay that fills it. Shown side by side; in a real model they share an
//    origin and print on separate toolheads.
translate([2 * SPACING, 0, 0]) {
    difference() {
        bin_blank(2, 1, 12);
        translate([0, 0, 12]) label_pocket("0.45", size = 9);
    }
    translate([0, -50, 0]) label_inlay("0.45", size = 9);
}
