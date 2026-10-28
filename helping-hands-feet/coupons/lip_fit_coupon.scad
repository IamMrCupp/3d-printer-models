// lip_fit_coupon — print first, IN TPU 95A. The v1.0.0 feet (plain 4.1 peg) fall
// out of the helping-hands plate. The hole goes through and the steel is just
// under 3 mm, so these feet carry a barb past the 3 mm shank that snaps through
// and catches behind the plate. This finds the lip size that goes through with a
// firm push and won't pull back out.
//
//   3 FEET   the real foot — 5 mm pad, 4.1 × 3 mm shank — with lips 4.4 / 4.6 / 4.8.
//            Pits in the pad's top count 1-3, smallest lip = 1 pit.
//   Want:    pushes through and clicks; lifting the plate by a foot doesn't pull
//            it out. Falls out → next size up; won't go through → next down.
//
// PRINT: as emitted, pads down, pegs up, in TPU. No supports. ~2 g.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp

include <../helping_hands_feet_common.scad>

LIPS   = [4.4, 4.6, 4.8];
PIT_D  = 1.6; PIT_H = 0.6;

for (i = [0:len(LIPS)-1]) translate([i * (FOOT_D + GAP), 0, 0]) difference() {
    foot(LIPS[i]);
    for (k = [0:i]) rotate([0, 0, -90 + (k - i/2) * 28])
        translate([4.3, 0, FOOT_H - PIT_H]) cylinder(d = PIT_D, h = PIT_H + 1, $fn = 16);
}
