// tool_carousel_common — a spinning three-tier tool carousel for the bench, after
// the "R38" organiser the user found: outer ring of handles, a middle tier, a
// centre ring of tweezer slots. Usable on and off the grid:
//
//   carousel   the spinning three-tier body; two 608 bearings pressed into its hub
//   base       round, flat-bottomed, an 8 mm post the bearings ride on; TPU feet
//              under it, so it works on a bare desk
//   dock       a 3×3 Gridfinity bin with a round pocket the base drops into
//   foot       TPU 95A puck, ×4, pressed into the base's underside
//
// EVERY NUMBER BELOW IS FROM survey/MEASUREMENTS.md (2026-10-06 → 10-09). The
// bearing fits were PRINTED and tested (two coupons); the tool sizes are the
// user's calipers. Clearances on tool holes are this design's choice and are
// named as such.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp

include <../lib/gridfinity.scad>

// ---- bearings: 608-2RS, fits measured on the U1 in PETG -------------------
BRG_OD    = 22.0;   // ISO 608
BRG_ID    = 8.0;
BRG_W     = 7.0;
BRG_RACE  = 12.0;   // the inner race's outer edge — the shoulder must stay inside it
SEAT_D    = 22.1;   // ✅ coupon round 1: press fit
POST_D    = 8.1;    // ✅ coupon round 2: snug slide (8.0 and under were loose)

// ---- tools: calipered by the user ------------------------------------------
DRIVER_D      = 17.0;   // rechargeable driver: a straight 17 mm tube, 160 long, back end down
DRIVER_BUTTON = 53;     // its buttons sit ~1/3 up (160/3) — a hole must stay shallower
GAMEBIT_SHAFT = 6.0;    // GameBit driver goes in shaft-down; shaft 30 long
GAMEBIT_SHAFT_L = 30;
GAMEBIT_HANDLE  = 22.0; // handle stands above the rim
PICK_D        = 8.0;    // largest of 6 double-ended picks
BRUSH_D       = 8.1;    // 2 metal glue-removal brushes, 120 long
TWEEZER_W     = 10.0;   // largest tweezers, ~20 mm up from the points
TWEEZER_T     = 2.75;
BLOCK_L       = 43.0;   // the rechargeable driver's 4 bit blocks (user rounded up)
BLOCK_W       = 10.0;
BLOCK_H       = 12.0;

N_PICKS = 6; N_BRUSHES = 2; N_TWEEZERS = 10; N_BLOCKS = 4;

// ---- clearances: this design's choice --------------------------------------
HOLE_CLR  = 0.6;    // on the diameter, round tool holes. The 22.1 seat pressing a
                    //   22.0 bearing says holes print ~0.1 under, so 0.6 drawn
                    //   is ~0.5 real: free to drop in, no rattle
SLOT_CLR  = 0.55;   // tweezer slots, each way
BLOCK_CLR = 0.6;    // bit-block pockets, each way (on top of the user's round-up)

// ---- the carousel ------------------------------------------------------------
CAR_D   = 124;          // overall; rides above the dock's rim, so it may exceed the base
R1      = CAR_D / 2;    // outer tier
R2      = 42;           // middle tier
R3      = 22;           // centre tier
H1      = 35;           // tier tops, from the carousel's underside
H2      = 47;
H3      = 62;
FLOOR   = 3;            // under every blind hole

HOLE_DEPTH    = 32;     // drivers, picks, brushes — well under the 53 mm buttons
BLOCK_DEPTH   = 8;      // of a 12 mm block: 4 mm stands proud to lift it out by
SLOT_DEPTH    = 25;

RING_R        = 52;     // outer-ring hole circle
GAMEBIT_R     = 55;     // pushed out so its ⌀22 handle clears the middle tier's wall by 2 mm;
                        //   the handle overhangs the rim by 4 mm, which is fine above it
BLOCK_IN      = 24;     // radius of the bit pockets' inner edge
SLOT_IN       = 8;      // tweezer slots run radially from here outward

// The hub: both bearings press up into one 22.1 bore from below. The upper one
// goes in first and is pushed to the bore's ceiling; the lower sits flush with
// the underside. Press fit holds each where it is put.
HUB_TOP   = 20;         // the bore's ceiling — upper bearing occupies 13..20
GAP       = 1.0;        // carousel underside above the base's top face

// ---- the base ----------------------------------------------------------------
BASE_D    = 120;
BASE_T    = 6;
SHOULDER_D = 11;        // under the lower bearing's INNER race only (< BRG_RACE)
POST_TOP  = GAP + HUB_TOP - 0.6;   // ends just below the hub ceiling
FOOT_D    = 12; FOOT_RECESS = 1.5; FOOT_PROUD = 1.5; FOOT_R = 46; N_FEET = 4;
FOOT_PRESS = 0.15;      // foot puck is this much larger than its recess, each side — TPU squeezes in

// ---- the dock ----------------------------------------------------------------
DOCK_N    = 3;          // 3×3 = 125.5 mm, the photo's 125
DOCK_POCKET_D = BASE_D + 1.0;
DOCK_POCKET_H = BASE_T; // pocket floor to rim
DOCK_FLOOR = 1.4;
DOCK_H    = BIN_BASE_H + DOCK_FLOOR + DOCK_POCKET_H;

// ---- outer ring: what sits where ---------------------------------------------
// Ten positions, 36° apart. The two drivers sit opposite each other so the
// carousel balances; picks and brushes fill the rest.
//   [angle, hole diameter, radius, depth]
RING = [
    [  0, DRIVER_D      + HOLE_CLR, RING_R,    HOLE_DEPTH],          // rechargeable driver
    [ 36, PICK_D        + HOLE_CLR, RING_R,    HOLE_DEPTH],
    [ 72, PICK_D        + HOLE_CLR, RING_R,    HOLE_DEPTH],
    [108, PICK_D        + HOLE_CLR, RING_R,    HOLE_DEPTH],
    [144, BRUSH_D       + HOLE_CLR, RING_R,    HOLE_DEPTH],
    [180, GAMEBIT_SHAFT + HOLE_CLR, GAMEBIT_R, GAMEBIT_SHAFT_L + 1], // GameBit: shaft in, handle rests on the rim
    [216, BRUSH_D       + HOLE_CLR, RING_R,    HOLE_DEPTH],
    [252, PICK_D        + HOLE_CLR, RING_R,    HOLE_DEPTH],
    [288, PICK_D        + HOLE_CLR, RING_R,    HOLE_DEPTH],
    [324, PICK_D        + HOLE_CLR, RING_R,    HOLE_DEPTH],
];

// ---- checks that the numbers above hang together ------------------------------
assert(HOLE_DEPTH < DRIVER_BUTTON, "Driver hole would swallow its buttons.");
assert(H1 - HOLE_DEPTH >= FLOOR, "Outer-ring holes break through the floor.");
assert(RING_R + (DRIVER_D + HOLE_CLR)/2 <= R1 - 1.2, "Driver hole breaks the outer wall.");
assert(RING_R - (DRIVER_D + HOLE_CLR)/2 >= R2 + 1.2, "Driver hole cuts into the middle tier.");
assert(GAMEBIT_R - GAMEBIT_HANDLE/2 >= R2 + 1.5, "GameBit handle too close to the middle tier's wall (it was measured as \"about\" 22).");
assert(GAMEBIT_R + (GAMEBIT_SHAFT + HOLE_CLR)/2 <= R1 - 2, "GameBit hole breaks the outer wall.");
assert(SHOULDER_D < BRG_RACE, "Shoulder would drag on the outer race.");
assert(H3 - SLOT_DEPTH > HUB_TOP + SEAT_D/2 + FLOOR, "Tweezer slots reach into the bearing hub's cone roof.");
assert(SLOT_IN + TWEEZER_W + 2*SLOT_CLR <= R3 - 2, "Tweezer slots break the centre tier's side.");
assert(BLOCK_DEPTH < BLOCK_H, "Blocks would sit flush — nothing to lift them by.");
assert(len([for (r = RING) if (abs(r[1] - (PICK_D + HOLE_CLR)) < 0.01) 1]) == N_PICKS, "Pick count drifted from RING.");
assert(len([for (r = RING) if (abs(r[1] - (BRUSH_D + HOLE_CLR)) < 0.01) 1]) == N_BRUSHES, "Brush count drifted from RING.");

$fn = 96;
EPS = 0.01;

// ---- carousel -------------------------------------------------------------------
// One turned body (three stacked cylinders as a single rotate_extrude — no
// coincident faces between tiers), minus the hub bore and the tool cavities.
module _tiers() {
    rotate_extrude($fn = 160)
        polygon([[0, 0], [R1, 0], [R1, H1], [R2, H1], [R2, H2], [R3, H2], [R3, H3], [0, H3]]);
}

module _bit_pocket() {
    // tangential: long side along the tier, inner edge at BLOCK_IN
    l = BLOCK_L + BLOCK_CLR; w = BLOCK_W + BLOCK_CLR;
    translate([BLOCK_IN, -l/2, H2 - BLOCK_DEPTH]) cube([w, l, BLOCK_DEPTH + 1]);
}

module _tweezer_slot() {
    l = TWEEZER_W + 2*SLOT_CLR; t = TWEEZER_T + 2*SLOT_CLR;
    translate([SLOT_IN, -t/2, H3 - SLOT_DEPTH]) cube([l, t, SLOT_DEPTH + 1]);
}

module carousel() {
    difference() {
        _tiers();
        // hub: one 22.1 bore from the underside up to HUB_TOP, both bearings in it.
        // Its roof is a 45° cone, not a flat 22 mm bridge: it prints unsupported,
        // and the cone's rim is what the upper bearing's outer race is pushed up to.
        translate([0, 0, -1]) cylinder(d = SEAT_D, h = HUB_TOP + 1);
        translate([0, 0, HUB_TOP - EPS]) cylinder(d1 = SEAT_D, d2 = 0, h = SEAT_D/2);
        // outer ring
        for (r = RING)
            rotate([0, 0, r[0]]) translate([r[2], 0, H1 - r[3]])
                cylinder(d = r[1], h = r[3] + 1);
        // bit blocks: four, square round the centre tier
        for (k = [0:N_BLOCKS-1]) rotate([0, 0, 45 + k*360/N_BLOCKS]) _bit_pocket();
        // tweezer ring
        for (k = [0:N_TWEEZERS-1]) rotate([0, 0, k*360/N_TWEEZERS]) _tweezer_slot();
    }
}

// ---- base -------------------------------------------------------------------------
// Prints feet-down. The post is solid with the disc; the shoulder ring under the
// lower bearing's inner race is what carries the carousel's weight.
module base() {
    difference() {
        union() {
            cylinder(d = BASE_D, h = BASE_T);
            // shoulder: a PARTIAL-area join onto the disc's top, so it overlaps
            translate([0, 0, BASE_T - 0.5]) cylinder(d = SHOULDER_D, h = GAP + 0.5);
            translate([0, 0, BASE_T - 0.5]) cylinder(d = POST_D, h = POST_TOP + 0.5);
            // lead-in on the post's tip so the bearings find it
            translate([0, 0, BASE_T + POST_TOP - EPS])
                cylinder(d1 = POST_D, d2 = POST_D - 1.2, h = 0.6);
        }
        for (k = [0:N_FEET-1]) rotate([0, 0, 45 + k*360/N_FEET])
            translate([FOOT_R, 0, -1]) cylinder(d = FOOT_D, h = FOOT_RECESS + 1);
    }
}

// TPU 95A. Slightly over the recess so it squeezes in and stays.
module foot() {
    cylinder(d = FOOT_D + 2*FOOT_PRESS, h = FOOT_RECESS + FOOT_PROUD, $fn = 64);
}

// ---- dock ----------------------------------------------------------------------------
module dock() {
    difference() {
        bin_blank(DOCK_N, DOCK_N, DOCK_H);
        translate([0, 0, BIN_BASE_H + DOCK_FLOOR]) cylinder(d = DOCK_POCKET_D, h = DOCK_H, $fn = 160);
    }
}

assert(DOCK_POCKET_D < DOCK_N*GF - 0.5 - 2*1.2, "Dock pocket breaks the bin's walls.");
