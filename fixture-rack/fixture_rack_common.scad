// fixture_rack_common — 5×2 Gridfinity storage rack for three repair fixtures, standing
// on edge like books. Storage, not use: the user's own sketch (2026-10-25).
//
// MEASURED BY THE USER (survey/MEASUREMENTS.md, 2026-10-25):
//   AMAOE M81 heat mat   190 × 245 × 8    on its 190 edge, 245 tall
//   RELIFE RL-605 Pro    179 × 210 × 24   on its 210 edge, 179 tall; knobs on both
//                                         ends about halfway up
//   RELIFE TF5           60 × 182 × 20    on its 182 edge (knobs included), 60 tall
//
// THE RL-605's SLOT HAS NO END WALLS. Five cells is 209.5 outside but ~207 inside
// the end walls, and the RL-605 is 210 long — so its slot runs straight out both
// ends, the plate sits across the whole length, and its knobs hang over the ends
// well above the rim (user's call). The other two fit inside walled slots.
//
// STEPPED, AS SKETCHED: the back section (mat, RL-605) stands BACK_H; the front
// section (TF5) steps down to FRONT_H so a hand gets in.
//
// PRINT: as emitted, feet down. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp

include <../lib/gridfinity.scad>

/* [Pieces — measured] */
// [name, standing length (on the floor), thickness]
MAT = [190, 8];
RL  = [210, 24];
TF5 = [182, 20];

/* [Rack] */
NX = 5; NY = 2;
CLR      = 4;      // added to each thickness — slots this much wider than the piece
WALL     = 2.4;    // outer walls
DIV      = 3.0;    // dividers — the RL-605 is the heavy one and leans on them
FLOOR    = 2.0;
BACK_H   = 60;     // above the floor: mat + RL-605, a third of the RL-605's 179
FRONT_H  = 30;     // TF5 section: half its 60 mm height

W = NX*GF - 0.5;  D = NY*GF - 0.5;
Z0 = BIN_BASE_H + FLOOR;
IN_X = W - 2*WALL;                       // inside the end walls

slots = [MAT[1] + CLR, RL[1] + CLR, TF5[1] + CLR];   // back → front
used  = slots[0] + slots[1] + slots[2] + 2*DIV;
y_back = D/2 - (D - used)/2;            // centre the group; outer walls take the rest
// back edge of each slot, going toward the front (−Y)
function y_top(i) = y_back - (i == 0 ? 0 : i == 1 ? slots[0] + DIV : slots[0] + slots[1] + 2*DIV);
step_y = y_top(2) + DIV/2;              // the step sits over the RL/TF5 divider's middle

assert(MAT[0] <= IN_X && TF5[0] <= IN_X, "Mat or TF5 longer than the walled slot.");
assert(RL[0] > IN_X, "RL-605 now fits inside end walls — give its slot end walls back.");
assert((D - used)/2 >= WALL, "Slots don't fit across two cells.");
echo(str("rack ", W, " × ", D, "; slots (back→front) ", slots, "; outer walls ", (D - used)/2,
         "; back ", Z0 + BACK_H, " tall, front ", Z0 + FRONT_H));

module slot(i, open_ends) {
    l = open_ends ? W + 2 : IN_X;
    translate([-l/2, y_top(i) - slots[i], Z0]) cube([l, slots[i], BACK_H + 1]);
}

module rack() {
    difference() {
        bin_blank(NX, NY, Z0 + BACK_H);
        slot(0, false);   // heat mat
        slot(1, true);    // RL-605: open both ends
        slot(2, false);   // TF5
        // the step: everything in front of it comes down to FRONT_H
        translate([-W, -D, Z0 + FRONT_H]) cube([2*W, step_y + D, BACK_H]);
    }
}

// A 20 mm slice through all three slots, flat-bottomed, walls COUPON_H tall: the
// same slot widths and dividers as the rack, for a few grams.
COUPON_L = 20;
COUPON_H = 15;
module coupon() {
    difference() {
        translate([-COUPON_L/2, -D/2, 0]) cube([COUPON_L, D, FLOOR + COUPON_H]);
        for (i = [0:2])
            translate([-COUPON_L, y_top(i) - slots[i], FLOOR]) cube([2*COUPON_L, slots[i], COUPON_H + 1]);
    }
}
