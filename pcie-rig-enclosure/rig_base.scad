// rig_base.scad — footed floor plate, tongue, screw bosses.
//
// Print as emitted: feet down. Four corner feet LATCH the plate; the twelve
// middle cells each get a solid BEARING foot that stands on the socket floor,
// is cut back so the click arms never touch it, and flares out above the
// plate top to within 0.4 mm of its neighbours. The floor spans nothing wider
// than one extrusion line. Every cell is on the bed; pull-off is four feet. The tongue round the edge is
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

// A cell's bearing foot: SOLID column to the plate top, then a 45-degree flare
// out until it meets its neighbours, at FLOOR_Z0. Solid on purpose — the
// ring-and-cross version left the floor bridging ~12,000 mm2 in 15 mm squares
// and it printed as spaghetti; "solid" in the model only costs the slicer's
// infill. The flare clears the click arms because it starts at the plate top,
// above the catch zone (foot z 0.8–2.6) and above the plate itself.
module bearing_foot() {
    e = 0.01;
    inset_lo = BIN_SZ/2 - BEAR_HW;          // 3.15 from the nominal foot outline
    inset_hi = inset_lo - FLARE_OUT;        // 0.15: 0.4 short of the cell line, no neighbour contact
    linear_extrude(PLATE_TOP_Z) _bin_cell(inset_lo);
    hull() {
        translate([0, 0, PLATE_TOP_Z - e]) linear_extrude(e) _bin_cell(inset_lo);
        translate([0, 0, FLOOR_Z0 - e])    linear_extrude(e) _bin_cell(inset_hi);
    }
}

// A corner's latching foot, with a straight column from the foot top up to the floor.
module latching_foot() {
    _bin_foot();
    translate([0, 0, BIN_BASE_H]) linear_extrude(FLOOR_Z0 - BIN_BASE_H) _bin_cell(0);
}

module base_feet() {
    for (ix = [0 : NX-1], iy = [0 : NY-1])
        translate([(ix-(NX-1)/2)*GF, (iy-(NY-1)/2)*GF, 0])
            if ((ix == 0 || ix == NX-1) && (iy == 0 || iy == NY-1)) latching_foot();
            else bearing_foot();
}

module rig_base() {
    difference() {
        union() {
            base_feet();
            translate([0, 0, FLOOR_Z0]) linear_extrude(FLOOR_T) rrect(W, D);
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
echo(str("rig_base: ", W, " x ", D, " x ", Z_FLOOR + TONGUE_H, " mm; floor top z=", Z_FLOOR, ", tongue ", REBATE, " x ", TONGUE_H, "; 4 latching + ", NX*NY-4, " solid bearing feet, flared from z=", PLATE_TOP_Z, " to ", FLOOR_Z0, ", floor spans <= 0.8 mm"));
assert(BEAR_HW < 18.25 - 0.5, "bearing foot would reach the click catches");
