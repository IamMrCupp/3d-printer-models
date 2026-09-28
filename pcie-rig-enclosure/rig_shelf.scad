// rig_shelf.scad — the plate between the drawer bay and the electronics.
//
// Sits on the frame's tongue, inside the cup's skirt; the cup's walls bear on
// it. Its front edge spans the drawer opening with nothing under it, so an
// upstand along that edge — inside the cup's front wall — stiffens it. The
// upstand is on TOP so the drawer bay stays clear.
//
// Prints flat, upstand up.

include <rig_common.scad>

UPSTAND_H = 6;
FRONT_Y   = -(D/2 - WALL);            // the cup's front wall comes down in front of this edge

module rig_shelf() {
    difference() {
        union() {
            linear_extrude(SHELF_T) intersection() {
                rrect(TONGUE_OUT_W, TONGUE_OUT_D, TONGUE_R);
                translate([-W/2, FRONT_Y]) square([W, D]);      // trim the front
            }
            translate([-(W/2 - WALL - 1), FRONT_Y + 0.3, SHELF_T])
                cube([W - 2*WALL - 2, WALL, UPSTAND_H]);
        }
    }
}

rig_shelf();
echo(str("rig_shelf: ", TONGUE_OUT_W, " x ", TONGUE_OUT_D/2 - FRONT_Y, " x ", SHELF_T, " (+", UPSTAND_H, " upstand)"));
