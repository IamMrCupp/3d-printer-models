// rig_cup.scad — top deck + four walls, open bottom. All the electronics.
//
// Modelled upright (deck on top, z = 0 at the open bottom edge) so the layout
// reads like the box. EMITTED UPSIDE DOWN for printing — deck face on the bed —
// so the meter cutout, switch hole, post holes and rail pockets all print in
// the first layers and the walls carry straight up. No supports.
//
//   deck   meter (housing cutout), rocker, probe post, two rail pockets
//   rear   12V IN +/- posts, fuse holder
//   right  pigtail exit — both 6+2 tails through one hole, zip tie inside
//   skirt  the bottom SKIRT_H of wall is REBATE thinner on the inside: it wraps
//          the frame's tongue and the shelf's edge. Four clearance holes for
//          the horizontal screws. No skirt on the front — nothing there to wrap.

include <rig_common.scad>

module cup_body() {
    difference() {
        linear_extrude(CUP_H) rrect(W, D);
        // interior, open at the bottom
        translate([0, 0, -1]) linear_extrude(SKIRT_H + CUP_IN_H + 1) rrect(W - 2*WALL, D - 2*WALL, BIN_R - WALL);
        // skirt: thin the wall from the inside over the bottom SKIRT_H, but
        // only where there is a tongue to wrap (left / right / rear)
        translate([0, 0, -1]) linear_extrude(SKIRT_H + 1) intersection() {
            rrect(SKIRT_IN_W, SKIRT_IN_D, SKIRT_IN_R);
            translate([-W, -(D/2 - WALL)]) square([2*W, 2*D]);
        }
        // front: no tongue below, and the drawer opening is right there — the
        // front wall stops at the tongue top, outer strip included (the first
        // cut of this kept a 1.5 mm lip across the opening; check_assembly.py
        // caught it). The side skirts end square at the rebate line.
        translate([0, 0, -1]) linear_extrude(TONGUE_H + 1) {
            translate([-W, -D]) square([2*W, D - (D/2 - REBATE)]);                 // y < rebate line
            translate([-SKIRT_IN_W/2, -D]) square([SKIRT_IN_W, D - (D/2 - WALL)]); // inside the skirts, y < wall
        }
    }
}

// Cuts through a wall along Y (rear) or X (right), centred at height z.
module rear_hole(x, z, d)  { translate([x, D/2, z]) rotate([90, 0, 0]) cylinder(d = d, h = WALL*3, center = true); }
module right_hole(y, z, d) { translate([W/2, y, z]) rotate([0, 90, 0]) cylinder(d = d, h = WALL*3, center = true); }

module deck_cutouts() {
    z0 = SKIRT_H + CUP_IN_H - 1; h = WALL + 2;
    // meter housing, with clearance per side
    translate([METER_X, METER_Y, z0]) linear_extrude(h)
        square([METER_W + 2*METER_CLR, METER_D + 2*METER_CLR], center = true);
    translate([SW_X, SW_Y, z0])  cylinder(d = SW_HOLE, h = h);
    translate([GND_X, GND_Y, z0]) cylinder(d = POST_HOLE, h = h);
    // rail pockets, recessed into the deck's top face
    for (sx = [-1, 1])
        translate([RISER_X + sx*RISER_HOLE_PITCH_L/2, RISER_Y, CUP_H - RAIL_POCKET])
            linear_extrude(RAIL_POCKET + 1) square([RAIL_W + 0.4, RAIL_L + 0.4], center = true);
}

module rig_cup() {
    difference() {
        cup_body();
        deck_cutouts();
        rear_hole(J1_X, WALL_Z, POST_HOLE);
        rear_hole(J2_X, WALL_Z, POST_HOLE);
        rear_hole(F1_X, WALL_Z, FUSE_HOLE);
        right_hole(TAILS_Y, WALL_Z, TAILS_HOLE);
        for (s = [-1, 1], y = [-BOSS_Y, BOSS_Y])
            translate([s * (W/2 + 1), y, SCREW_Z]) rotate([0, -s*90, 0]) cylinder(d = SCREW_CLR, h = REBATE + 2);
    }
}

// Print orientation: flip so the deck is on the bed.
translate([0, 0, CUP_H]) rotate([180, 0, 0]) rig_cup();

// Fit sanity, so a layout edit can't silently walk a part into a wall.
assert(abs(METER_X) + METER_W/2 + METER_CLR < W/2 - WALL, "meter housing hits a side wall");
assert(abs(METER_Y) + METER_D/2 + METER_CLR < D/2 - WALL, "meter housing hits the front/rear wall");
assert(METER_DEPTH < CUP_IN_H - 5, "meter needs more room under the deck");
assert(abs(RISER_X) + RISER_L/2 <= W/2, "riser board overhangs the deck");
assert(RISER_Y - RISER_W/2 > METER_Y + 49/2, "riser board sits on the meter bezel");
assert(SW_X - 23/2 > METER_X + 89/2, "rocker bezel overlaps the meter bezel");
echo(str("rig_cup: ", W, " x ", D, " x ", CUP_H, " mm, deck ", WALL, " thick, ", CUP_IN_H, " clear above the shelf, skirt ", SKIRT_H));
