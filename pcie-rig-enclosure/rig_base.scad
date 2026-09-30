// rig_base.scad — footed floor plate, tongue, screw bosses.
//
// Print as emitted: feet down. Four corner feet LATCH the plate; the twelve
// middle cells each get a BEARING foot — a ring with a cross inside — that
// stands on the socket floor but is cut back so the click arms never touch
// it. Every cell has something on the bed, so nothing on this part bridges;
// the pull-off force is still four feet (~49 N). The tongue round the edge is
// what the cup's skirt wraps; the four bosses behind it take the screws. The
// floor is the electronics floor — the WAGO ground bus sits on it.
//
// WHY BEARING FEET AND NOT RIBS. The first revision copied lib's filler tile:
// corner feet + ribs on the cell lines + the floor over them. The filler tile
// prints UPSIDE DOWN so that works; this part can't (the tongue is on top),
// and printed feet-down the ribs started 2.8 mm up in mid-air and the floor
// 4.75 mm up — 84 mm bridges along every edge. It printed with strings and
// droop off every edge (2026-09-29). Bearing feet put material on the bed
// under every cell instead.
//
// WHY THEY DON'T LATCH. A Clickfinity catch reaches ARM_ENGAGE (0.60) past the
// socket wall: SOCK_HW 18.85 -> 18.25 from the cell centre. A latching foot's
// vertical wall is at 18.60, which is what the catch grips. The bearing foot
// stops at BEAR_HW below, 0.65 short of the catch and 1.25 short of the wall.

include <rig_common.scad>

BEAR_HW   = 17.60;   // half-width of a bearing foot. Catch reaches 18.25 — see header
BEAR_WALL = 1.60;    // its ring wall
BEAR_BAR  = 2.40;    // the cross inside, so the floor above spans <= ~16 mm

// A cell's bearing foot: rounded-square ring + cross, socket floor to foot top.
module bearing_foot() {
    inset = BIN_SZ/2 - BEAR_HW;                       // from the nominal foot outline
    linear_extrude(BIN_BASE_H) {
        difference() { _bin_cell(inset); _bin_cell(inset + BEAR_WALL); }
        square([2*BEAR_HW - 1, BEAR_BAR], center = true);
        square([BEAR_BAR, 2*BEAR_HW - 1], center = true);
    }
}

module base_feet() {
    for (ix = [0 : NX-1], iy = [0 : NY-1])
        translate([(ix-(NX-1)/2)*GF, (iy-(NY-1)/2)*GF, 0])
            if ((ix == 0 || ix == NX-1) && (iy == 0 || iy == NY-1)) _bin_foot();   // corners latch
            else bearing_foot();                                                   // the rest bear
}

module rig_base() {
    difference() {
        union() {
            base_feet();
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
echo(str("rig_base: ", W, " x ", D, " x ", Z_FLOOR + TONGUE_H, " mm; floor top z=", Z_FLOOR, ", tongue ", REBATE, " x ", TONGUE_H, "; 4 latching + ", NX*NY-4, " bearing feet"));
assert(BEAR_HW < 18.25 - 0.5, "bearing foot would reach the click catches");
