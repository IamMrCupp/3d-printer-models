// rig_cup.scad — top deck + four walls, open bottom. All the electronics.
//
// Modelled upright (deck on top, z = 0 at the open bottom edge) so the layout
// reads like the box. EMITTED UPSIDE DOWN for printing — deck face on the bed —
// so the meter cutout, switch hole, post holes and rail pockets all print in
// the first layers and the walls carry straight up. No supports.
//
//   deck   meter (housing cutout), rocker, probe post, two rail pockets
//   rear   XT60E-M input (cutout gated on XT60M_MEASURED) + 12V IN +/- posts + 5x20 fuse
//   right  XT60E-F output(s) (gated) + OUT +/- posts
//   labels engraved: 12V IN, FUSE, RISER / CARD, OUT, GND, and +/- by every post.
//          rig_cup_inlay.scad emits the matching inlays for a second colour.
//   skirt  the bottom SKIRT_H of wall is REBATE thinner on the inside, all
//          four sides: it wraps the base's tongue. Four clearance holes for
//          the horizontal screws.

include <rig_common.scad>

INLAY = false;   // rig_cup_inlay.scad sets this true: emit the label inlays only, same origin

module cup_body() {
    difference() {
        linear_extrude(CUP_H) rrect(W, D);
        // interior, open at the bottom
        translate([0, 0, -1]) linear_extrude(CUP_IN_H + 1) rrect(W - 2*WALL, D - 2*WALL, BIN_R - WALL);
        // skirt: thin the wall from the inside over the bottom SKIRT_H
        translate([0, 0, -1]) linear_extrude(SKIRT_H + 1) rrect(SKIRT_IN_W, SKIRT_IN_D, SKIRT_IN_R);
    }
}

// Cuts through a wall along Y (rear) or X (right), centred at height z.
module rear_hole(x, z, d)  { translate([x, D/2, z]) rotate([90, 0, 0]) cylinder(d = d, h = WALL*3, center = true); }
module right_hole(y, z, d) { translate([W/2, y, z]) rotate([0, 90, 0]) cylinder(d = d, h = WALL*3, center = true); }

module deck_cutouts() {
    z0 = CUP_IN_H - 1; h = WALL + 2;
    // meter housing, with clearance per side
    translate([METER_X, METER_Y, z0]) linear_extrude(h)
        square([METER_W + 2*METER_CLR_L, METER_D + 2*METER_CLR_S], center = true);
    translate([SW_X, SW_Y, z0])  cylinder(d = SW_HOLE, h = h);
    translate([GND_X, GND_Y, z0]) cylinder(d = POST_HOLE, h = h);
    // rail pockets, recessed into the deck's top face
    for (sx = [-1, 1])
        translate([RISER_X + sx*RISER_HOLE_PITCH_L/2, RISER_Y, CUP_H - RAIL_POCKET])
            linear_extrude(RAIL_POCKET + 1) square([RAIL_W + 0.4, RAIL_L + 0.4], center = true);
}

// An XT60E panel cutout: body rectangle (+ clearance) + two ear holes. Only once measured.
//   x = [cut W, cut H, ear pitch, ear dia, depth, flange W, flange H]
module xt60_cut(x, measured) {
    if (measured) {
        cube([x[0] + 2*XT60_CLR, x[1] + 2*XT60_CLR, WALL*3], center = true);
        for (sx = [-1, 1]) translate([sx*x[2]/2, 0, 0]) cylinder(d = x[3], h = WALL*3, center = true);
    }
}
module rear_xt60(x, z)  { translate([x, D/2, z]) rotate([90, 0, 0]) xt60_cut(XT60M, XT60M_MEASURED); }
module right_xt60(y, z) { translate([W/2, y, z]) rotate([90, 0, 90]) xt60_cut(XT60F, XT60F_MEASURED); }

module _pocket_v(txt) { if (INLAY) label_inlay_v(txt, LABEL_SIZE, LABEL_DEPTH); else label_pocket_v(txt, LABEL_SIZE, LABEL_DEPTH); }
module _pocket_h(txt) { if (INLAY) label_inlay(txt, LABEL_SIZE, LABEL_DEPTH);   else label_pocket(txt, LABEL_SIZE, LABEL_DEPTH); }
module rear_label(txt, x, z)  { translate([x, D/2, z]) mirror([1, 0, 0]) _pocket_v(txt); }
module right_label(txt, y, z) { translate([W/2, y, z]) rotate([0, 0, -90]) mirror([1, 0, 0]) _pocket_v(txt); }
module deck_label(txt, x, y)  { translate([x, y, CUP_H]) _pocket_h(txt); }

// Every label on the cup, placed once: subtracted from the part, or emitted
// alone as the second-colour inlay.
module cup_labels() {
    rear_label("12V IN", (XT60_IN_X + J2_MINUS_X)/2, WALL_Z + XT60M[6]/2 + 5);
    rear_label("+", J2_PLUS_X, WALL_Z - LABEL_LIFT);
    rear_label("-", J2_MINUS_X, WALL_Z - LABEL_LIFT);
    rear_label("FUSE", F1_X, WALL_Z + LABEL_LIFT + 2);
    for (i = [0 : XT60_OUT_N - 1])
        right_label(i == 0 ? "RISER" : "CARD", XT60_OUT_Y[i], WALL_Z + XT60F[6]/2 + 5);
    right_label("OUT", (J5_PLUS_Y + J5_MINUS_Y)/2, WALL_Z + LABEL_LIFT + 2);
    right_label("+", J5_PLUS_Y, WALL_Z - LABEL_LIFT);
    right_label("-", J5_MINUS_Y, WALL_Z - LABEL_LIFT);
    deck_label("GND", GND_X, GND_Y - LABEL_LIFT);
}

module rig_cup() {
    if (INLAY) cup_labels();
    else difference() {
        cup_body();
        deck_cutouts();
        // rear: input
        rear_xt60(XT60_IN_X, WALL_Z);
        rear_hole(J2_PLUS_X, WALL_Z, POST_HOLE);
        rear_hole(J2_MINUS_X, WALL_Z, POST_HOLE);
        rear_hole(F1_X, WALL_Z, FUSE_HOLE);
        // right: outputs
        for (i = [0 : XT60_OUT_N - 1]) right_xt60(XT60_OUT_Y[i], WALL_Z);
        right_hole(J5_PLUS_Y, WALL_Z, POST_HOLE);
        right_hole(J5_MINUS_Y, WALL_Z, POST_HOLE);
        cup_labels();
        // skirt screw clearance
        for (s = [-1, 1], y = [-BOSS_Y, BOSS_Y])
            translate([s * (W/2 + 1), y, SCREW_Z]) rotate([0, -s*90, 0]) cylinder(d = SCREW_CLR, h = REBATE + 2);
    }
}

// Print orientation: flip so the deck is on the bed.
translate([0, 0, CUP_H]) rotate([180, 0, 0]) rig_cup();

// Fit sanity, so a layout edit can't silently walk a part into a wall.
assert(abs(METER_X) + METER_W/2 + METER_CLR_L < W/2 - WALL, "meter housing hits a side wall");
assert(abs(METER_Y) + METER_D/2 + METER_CLR_S < D/2 - WALL, "meter housing hits the front/rear wall");
assert(F1_X - 8 > J2_MINUS_X + 6 && F1_X + 8 < W/2 - WALL, "fuse holder crowds a post or the wall");
assert(METER_DEPTH < CUP_IN_H - 5, "meter needs more room under the deck");
assert(abs(RISER_X) + RISER_L/2 <= W/2, "riser board overhangs the deck");
assert(RISER_Y - RISER_W/2 > METER_Y + 49/2, "riser board sits on the meter bezel");
assert(SW_X - 23/2 > METER_X + 89/2, "rocker bezel overlaps the meter bezel");
assert(GND_X + 6 < W/2 - WALL && GND_Y - 6 > -(D/2 - WALL), "probe post nut hits a wall");
assert(GND_Y + 6 < XT60_OUT_Y[0] - XT60F[0]/2 - XT60_CLR, "probe post nut sits where the RISER output's body comes through");
assert(XT60_OUT_N == 1 || XT60_OUT_Y[1] - XT60_OUT_Y[0] >= XT60F[5] + 3, "XT60 output flanges overlap");
assert(XT60_OUT_Y[XT60_OUT_N - 1] + XT60F[5]/2 + 3 < J5_PLUS_Y - 6, "CARD flange runs into the OUT + post");
assert(WALL_Z + XT60F[6]/2 + 5 + LABEL_SIZE/2 < CUP_IN_H, "RISER/CARD label runs into the deck");
assert(XT60_IN_X + XT60M[5]/2 + 3 < J2_PLUS_X - 6, "12V IN flange runs into the + post");
if (!XT60M_MEASURED) echo("WARNING: XT60E-M cutout NOT cut — body behind the flange not yet measured.");
if (!XT60F_MEASURED) echo("WARNING: XT60E-F cutouts NOT cut.");
echo(str("rig_cup: ", W, " x ", D, " x ", CUP_H, " mm, deck ", WALL, " thick, ", CUP_IN_H, " clear above the base floor, skirt ", SKIRT_H));
