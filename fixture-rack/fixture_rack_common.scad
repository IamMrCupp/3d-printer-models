// fixture_rack_common — 5×2 Gridfinity storage rack for three repair fixtures, standing
// on edge like books. Storage, not use: the user's own sketch (2026-10-25).
//
// MEASURED BY THE USER (survey/MEASUREMENTS.md, 2026-10-25):
//   AMAOE M81 heat mat   190 × 245 × 8    on its 190 edge, 245 tall
//   RELIFE RL-605 Pro    179 × 210 × 24   on its 210 edge, 179 tall; knobs on both
//                                         ends about halfway up
//   RELIFE TF5           60 × 182 × 20    on its 182 edge (knobs included), 60 tall
//
// EVERY SLOT HAS END WALLS, so nothing slides out of the rack (v1.0.0 left the
// RL-605's slot open at both ends; the user rejected that, 2026-10-25). The
// RL-605's slot gets 1.2 mm end walls instead of 2.4, the most length 5 cells
// allow: ~207 mm inside. Its 210 was measured in pieces with a 155 mm caliper and
// ran long — the user confirmed all three fit the layout coupon. Its knobs sit
// halfway up each end, well above the walls.
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
RL_END   = 1.2;    // the RL-605 slot's end walls — thinner, for length
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
RL_IN_X = W - 2*RL_END;                 // inside the RL-605 slot's thinner end walls
assert((D - used)/2 >= WALL, "Slots don't fit across two cells.");
echo(str("rack ", W, " × ", D, "; slots (back→front) ", slots, "; inside length ", IN_X, " (RL-605 ", RL_IN_X, "); outer walls ", (D - used)/2,
         "; back ", Z0 + BACK_H, " tall, front ", Z0 + FRONT_H));

module slot(i, l) {
    translate([-l/2, y_top(i) - slots[i], Z0]) cube([l, slots[i], BACK_H + 1]);
}

module rack() {
    difference() {
        bin_blank(NX, NY, Z0 + BACK_H);
        slot(0, IN_X);      // heat mat
        slot(1, RL_IN_X);   // RL-605: thinner end walls, still closed
        slot(2, IN_X);      // TF5
        // the step: everything in front of it comes down to FRONT_H
        translate([-W, -D, Z0 + FRONT_H]) cube([2*W, step_y + D, BACK_H]);
    }
}

// LAYOUT COUPON: the rack's exact top-view outline — outer walls, dividers, end
// walls, the RL-605's open ends — at full length but only FRAME_H tall, with no
// floor and no feet. Lay each fixture in its slot to check length AND thickness
// for ~25 g instead of the whole rack.
FRAME_H = 5;
TIE_T   = 1;   // floor strip under the RL-605 slot only. Its open ends would
               // otherwise cut the frame into two loose halves; the rack's own
               // floor does this job. It runs 1 mm under each divider, a
               // partial-area join, so it overlaps rather than butts.
module layout_coupon() {
    translate([-W/2, y_top(1) - slots[1] - 1, 0]) cube([W, slots[1] + 2, TIE_T]);
    linear_extrude(FRAME_H) difference() {
        offset(r = BIN_R) offset(delta = -BIN_R) square([W, D], center = true);
        for (i = [0:2]) {
            l = (i == 1) ? W + 2 : IN_X;     // as printed 2026-10-25: RL-605 slot open
            translate([-l/2, y_top(i) - slots[i]]) square([l, slots[i]]);
        }
    }
}
