// bearing_fit_coupon — print first. Finds the printed seat and post sizes that
// fit a 608-2RS bearing, before the tool carousel's hub and base are cut.
//
// The bearing is an ISO-standard 608: 8 ID × 22 OD × 7 mm (100 on hand,
// survey/MEASUREMENTS.md 2026-10-06). The bearing's own size is trustworthy; what
// a PETG print makes of a 22 mm hole or an 8 mm pin is not, and that is all this
// answers.
//
//   4 SEATS (rings)   bore 21.9 / 22.1 / 22.3 / 22.5, 7 mm deep on a 1 mm ledge.
//                     Want: the bearing presses in by thumb and stays put upside
//                     down. Push it back out through the bottom opening.
//   4 POSTS           8 mm-nominal pins at 7.7 / 7.8 / 7.9 / 8.0, 10 mm tall.
//                     Want: the bearing slides on with no rocking and spins
//                     freely all the way down to the shoulder.
//
// WHICH IS WHICH: raised dots on each feature count 1-4, smallest size = 1 dot —
// on the top rim of each seat, and on the shoulder around each post. Seats and posts both run small → large from the left.
//
// PRINT: flat as emitted, no supports. ~12 g.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp

SEATS = [21.9, 22.1, 22.3, 22.5];   // bore, on the diameter
POSTS = [7.7, 7.8, 7.9, 8.0];       // pin diameter

BEARING_W  = 7.0;     // 608 width — the seat depth
LEDGE      = 1.0;     // floor ring the bearing's outer race rests on
LEDGE_ID   = 20.0;    // opens the floor so the bearing can be pushed out; 1 mm
                      //   of ledge stays under the outer race only
RING_WALL  = 2.4;
POST_H     = 10.0;    // longer than the 7 mm bearing so it seats fully
POST_CHAM  = 0.6;
SPINE_T    = 2.0;
SPINE_W    = 6.0;
PAD_D      = 14.0;    // each post's foot; its top is the shoulder
DOT_D      = 1.6;
DOT_H      = 0.6;
JOIN       = 1.0;     // how far rings and pads overlap the spine — partial-area
                      //   joins, so they overlap volumetrically, never butt
$fn = 128;

ring_od   = max(SEATS) + 2*RING_WALL;
ring_h    = LEDGE + BEARING_W;
ring_pitch = ring_od + 3;
post_pitch = PAD_D + 3;
n_seat = len(SEATS); n_post = len(POSTS);
spine_l = max(n_seat*ring_pitch, n_post*post_pitch);

assert(LEDGE_ID < min(SEATS) - 1.5, "Ledge too narrow to hold the outer race.");
assert(LEDGE_ID > 19.0, "Ledge would touch the inner race / seals.");
assert(PAD_D > max(POSTS) + 4, "Post foot too small to be a shoulder.");

function seat_x(i) = ring_pitch*(i + 0.5);
function post_x(i) = post_pitch*(i + 0.5);

// n dots on an arc of radius r about the feature's centre, at height z, centred
// on angle a0 — so each count sits ON the feature it labels, not near it.
module dots(n, r, z, a0) {
    step = 2.4 / r * 180 / PI;          // 2.4 mm apart along the arc
    for (k = [0:n-1])
        rotate([0, 0, a0 + (k - (n-1)/2) * step])
            translate([r, 0, z - 0.01]) cylinder(d = DOT_D, h = DOT_H + 0.01, $fn = 16);
}

module seat(d) {
    difference() {
        cylinder(d = ring_od, h = ring_h);
        translate([0, 0, LEDGE]) cylinder(d = d, h = ring_h);      // the seat
        translate([0, 0, -1])    cylinder(d = LEDGE_ID, h = ring_h + 2); // push-out hole
    }
}

module post(d) {
    cylinder(d = PAD_D, h = SPINE_T);
    translate([0, 0, SPINE_T - 0.01]) {
        cylinder(d = d, h = POST_H - POST_CHAM + 0.01);
        translate([0, 0, POST_H - POST_CHAM])
            cylinder(d1 = d, d2 = d - 2*POST_CHAM, h = POST_CHAM);
    }
}

union() {
    cube([spine_l, SPINE_W, SPINE_T]);
    for (i = [0:n_seat-1])
        translate([seat_x(i), -ring_od/2 + JOIN, 0]) {
            seat(SEATS[i]);
            // on the ring's top rim, on the side away from the spine
            dots(i + 1, (max(SEATS)/2 + ring_od/2) / 2, ring_h, 270);
        }
    for (i = [0:n_post-1])
        translate([post_x(i), SPINE_W + PAD_D/2 - JOIN, 0]) {
            post(POSTS[i]);
            // on the shoulder, on the side away from the spine
            dots(i + 1, (max(POSTS)/2 + PAD_D/2) / 2, SPINE_T, 90);
        }
}
