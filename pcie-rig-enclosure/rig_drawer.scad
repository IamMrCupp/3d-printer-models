// rig_drawer.scad — the cord drawer.
//
// Two compartments: the wide one for the spare 6+2 cables and the 12VHPWR
// lead, the narrow one on the right for the riser's x1 card and its USB lead.
// Finger notch in the front. Prints open-top up, no supports.
//
// Narrower than the bay by 2 x BOSS_IN + 1 so it slides past the frame's
// screw bosses; its front face comes flush with the frame's front edge.

include <rig_common.scad>

module rig_drawer() {
    iw = DRAWER_W - 2*DRAWER_WALL;
    id = DRAWER_D - 2*DRAWER_WALL;
    x1_w   = X1_BAY_W;                          // right-hand compartment, inner
    cord_w = iw - x1_w - DRAWER_WALL;           // what's left on the left
    assert(cord_w > 80, "cord compartment has gone too narrow");
    difference() {
        translate([-DRAWER_W/2, -DRAWER_D/2, 0]) cube([DRAWER_W, DRAWER_D, DRAWER_H]);
        // cord compartment
        translate([-DRAWER_W/2 + DRAWER_WALL, -id/2, DRAWER_FLOOR]) cube([cord_w, id, DRAWER_H]);
        // x1 card + USB compartment
        translate([DRAWER_W/2 - DRAWER_WALL - x1_w, -id/2, DRAWER_FLOOR]) cube([x1_w, id, DRAWER_H]);
        // finger pull, a half-round out of the front wall's top edge
        translate([0, -DRAWER_D/2, DRAWER_H]) rotate([90, 0, 0]) cylinder(r = PULL_R, h = DRAWER_WALL*3, center = true);
    }
}

rig_drawer();
echo(str("rig_drawer: ", DRAWER_W, " x ", DRAWER_D, " x ", DRAWER_H, " mm; x1 bay ", X1_BAY_W, " wide"));
