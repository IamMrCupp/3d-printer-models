// rig_base.scad — footed floor plate, tongue, screw bosses.
//
// Print as emitted: feet down. Four corner feet latch the plate; the ribs
// between them bear on the grid walls at PLATE_TOP. The tongue round the edge
// is what the cup's skirt wraps; the four bosses behind it take the screws.
// The floor is the electronics floor — the blade fuse holder and the WAGO
// ground bus sit on it, on their wires.

include <rig_common.scad>

module base_feet_and_ribs() {
    for (ix = [0, NX-1], iy = [0, NY-1])
        translate([(ix-(NX-1)/2)*GF, (iy-(NY-1)/2)*GF, 0]) _bin_foot();
    translate([0, 0, PLATE_TOP]) linear_extrude(BIN_BASE_H - PLATE_TOP) {
        difference() { rrect(W, D); rrect(W - 2*RIB_T, D - 2*RIB_T); }
        for (i = [1 : NX-1]) translate([(i - NX/2)*GF, 0]) square([RIB_T, D], center = true);
        for (i = [1 : NY-1]) translate([0, (i - NY/2)*GF]) square([W, RIB_T], center = true);
    }
}

module rig_base() {
    difference() {
        union() {
            base_feet_and_ribs();
            translate([0, 0, BIN_BASE_H]) linear_extrude(FLOOR_T) rrect(W, D);
            // tongue: a rim, REBATE thick, TONGUE_H tall, set in from the edge
            translate([0, 0, Z_FLOOR]) linear_extrude(TONGUE_H)
                difference() { rrect(TONGUE_OUT_W, TONGUE_OUT_D, TONGUE_R); rrect(TONGUE_IN_W, TONGUE_IN_D, TONGUE_IN_R); }
            for (s = [-1, 1], y = [-BOSS_Y, BOSS_Y]) tongue_boss(s, y);
        }
        // screw pilots, horizontal, through tongue and boss
        for (s = [-1, 1], y = [-BOSS_Y, BOSS_Y])
            translate([s * (W/2 + 1), y, Z_FLOOR + SCREW_Z])
                rotate([0, -s*90, 0]) cylinder(d = SCREW_TAP, h = 1 + REBATE + JOINT_CLR + REBATE + BOSS_IN + 1);
    }
}

rig_base();
echo(str("rig_base: ", W, " x ", D, " x ", Z_FLOOR + TONGUE_H, " mm; floor top z=", Z_FLOOR, ", tongue ", REBATE, " x ", TONGUE_H));
