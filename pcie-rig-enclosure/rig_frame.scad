// rig_frame.scad — footed floor + three walls: the drawer bay.
//
// Print as emitted: feet down. Four corner feet latch the plate; the ribs
// between them bear on the grid walls at PLATE_TOP. Open at the front (-Y).
//
// The rim is rebated to a tongue that the cup's skirt wraps. Two bosses on
// each side wall, behind the tongue, take the horizontal screws that hold the
// cup on. They stand BOSS_IN into the bay, which is why the drawer is narrower
// than the bay by twice that.

include <rig_common.scad>

Z_FLOOR = BIN_BASE_H + FLOOR_T;     // top of the floor
Z_RIM   = Z_FLOOR + BAY_H;          // top of the tongue — the shelf sits here

module frame_feet_and_ribs() {
    for (ix = [0, NX-1], iy = [0, NY-1])
        translate([(ix-(NX-1)/2)*GF, (iy-(NY-1)/2)*GF, 0]) _bin_foot();
    translate([0, 0, PLATE_TOP]) linear_extrude(BIN_BASE_H - PLATE_TOP) {
        difference() { rrect(W, D); rrect(W - 2*RIB_T, D - 2*RIB_T); }
        for (i = [1 : NX-1]) translate([(i - NX/2)*GF, 0]) square([RIB_T, D], center = true);
        for (i = [1 : NY-1]) translate([0, (i - NY/2)*GF]) square([W, RIB_T], center = true);
    }
}

module rig_frame() {
    difference() {
        union() {
            frame_feet_and_ribs();
            difference() {
                // floor + walls as one prism, then sweep the bay out through the front
                translate([0, 0, BIN_BASE_H]) linear_extrude(Z_RIM - BIN_BASE_H) rrect(W, D);
                translate([0, 0, Z_FLOOR]) linear_extrude(BAY_H + 1)
                    _stack_pocket(W - 2*WALL, D - 2*WALL, BIN_R - WALL, D);
            }
            for (s = [-1, 1], y = [-BOSS_Y, BOSS_Y]) wall_boss(s, y, Z_RIM);
        }
        // rebate: the outer REBATE of the rim, over TONGUE_H, comes off
        translate([0, 0, Z_RIM - TONGUE_H]) linear_extrude(TONGUE_H + 1)
            difference() { rrect(W + 2, D + 2); rrect(TONGUE_OUT_W, TONGUE_OUT_D, TONGUE_R); }
        // screw pilots, horizontal, through tongue and boss
        for (s = [-1, 1], y = [-BOSS_Y, BOSS_Y])
            translate([s * (W/2 + 1), y, Z_RIM - TONGUE_H + SCREW_Z])
                rotate([0, -s*90, 0]) cylinder(d = SCREW_TAP, h = 1 + WALL + BOSS_IN + 1);
    }
}

rig_frame();
echo(str("rig_frame: ", W, " x ", D, " x ", Z_RIM, " mm; bay ", W - 2*WALL, " wide x ", BAY_H, " tall; tongue top z=", Z_RIM));
