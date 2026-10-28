// helping_hands_feet_common — pegged TPU 95A replacement feet for a helping-hands
// plate that arrived with a foot missing. The stock feet are glued over two holes;
// these press into the holes instead.
//
// MEASURED / TESTED (survey/MEASUREMENTS.md):
//   hole           3.83 mm (calipers, 2026-10-26)
//   peg            4.1 mm — the 4-dot peg on coupons/peg_fit_coupon.scad pressed in
//                  best (TPU squeezes in over the hole and grips), 2026-10-27
//   peg length     3 mm — "perfect" on the coupon
//   foot           5 mm tall (user); pad ⌀12 kept from the coupon (assumed)
//   count          2 — the plate has two holes
//
// PRINT: in TPU 95A, pads down, pegs up, as emitted. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp

PEG_D    = 4.1;
PEG_L    = 3.0;
PEG_CHAM = 0.4;
FOOT_H   = 5.0;
FOOT_D   = 12.0;
FOOT_CHAM = 0.6;   // softens the bottom edge so it doesn't curl or catch
N_FEET   = 2;
GAP      = 6;      // between feet on the bed

$fn = 64;

module foot() {
    // pad: a turned profile with a small chamfer on the bottom edge
    rotate_extrude() polygon([[0, 0], [FOOT_D/2 - FOOT_CHAM, 0], [FOOT_D/2, FOOT_CHAM],
                              [FOOT_D/2, FOOT_H], [0, FOOT_H]]);
    // peg: a PARTIAL-area join onto the pad's top, so it overlaps rather than butts
    translate([0, 0, FOOT_H - 0.4]) {
        cylinder(d = PEG_D, h = PEG_L - PEG_CHAM + 0.4);
        translate([0, 0, PEG_L - PEG_CHAM + 0.4 - 0.01])
            cylinder(d1 = PEG_D, d2 = PEG_D - 2*PEG_CHAM, h = PEG_CHAM);
    }
}

module feet() { for (i = [0:N_FEET-1]) translate([i * (FOOT_D + GAP), 0, 0]) foot(); }
