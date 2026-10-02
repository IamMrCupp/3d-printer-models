// rig_dock_rail.scad — SUPERSEDED by rig_storage_bin. Kept for the record.
//
// Its pegs sat on the calipered 99 x 37 hole pitch, which was never coupon-tested
// for pitch, and missed the board's holes in both directions on the printed cup
// (2026-10-01). Lives in coupons/ so releases don't ship it as a part.
//
// Original note: one of two rails that hold the x16 riser on the deck.
//
// The board (PCE164P-N03 VER 006C) has the x16 slot flush along one long edge,
// capacitors crowding the other, and the 6-pin + USB filling a short end, so
// there's no clean edge to clip. It does have four mounting holes on a 99 x 37
// pitch, so: two pegs per rail, one rail under each end of the board. The
// board lies on its own factory foam pad; the pegs reach through 4 mm of foam
// + PCB and stand 1.2 proud.
//
// The rail sits flush in a pocket on the deck and is CA-glued. It's a
// separate part because the cup prints deck-down and a peg can't grow off the
// face that's on the bed.
//
// PEG_D is the fit that matters — print coupons/dock_rail_ladder.scad first.

include <../rig_common.scad>

module rig_dock_rail(peg_d = PEG_D) {
    peg_h = PEG_H_ABOVE_DECK - (RAIL_T - RAIL_POCKET);   // above the rail's top
    union() {
        translate([-RAIL_W/2, -RAIL_L/2, 0]) cube([RAIL_W, RAIL_L, RAIL_T]);
        for (sy = [-1, 1])
            translate([0, sy*RISER_HOLE_PITCH_W/2, RAIL_T]) {
                cylinder(d = peg_d, h = peg_h - 0.6);
                translate([0, 0, peg_h - 0.6]) cylinder(d1 = peg_d, d2 = peg_d - 1.0, h = 0.6);  // lead-in
            }
    }
}

rig_dock_rail();
echo(str("rig_dock_rail: ", RAIL_W, " x ", RAIL_L, ", pegs ", PEG_D, " at ", RISER_HOLE_PITCH_W, " pitch"));
