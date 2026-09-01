// plate_heat_gun — 2×2 Gridfinity plate that the heat gun's magnetic bracket
// bolts to FROM BELOW, on a 20° ramp.
//
// HOW YOU USE IT:
//   Sit the bracket on the plate, drop four screws up through the plate from
//   underneath, into the bracket's own threads. The gun parks on the magnet as
//   usual, and the whole assembly lifts off the grid as one piece.
//
// ⚠️ THIS REPLACES A PLATE THAT SCREWED FROM THE TOP, AND IT IS NOT A TWEAK.
// v1.0.x had four BLIND 2.22 mm pilot holes 10 mm deep in a 12 mm deck: screws
// went DOWN through the bracket and self-tapped into the plastic. The bracket
// turns out to take screws only from its underside, which inverts every one of
// those decisions:
//
//   blind pilot  ->  through hole at CLEARANCE (a pilot would bind the shank)
//   head on top  ->  head RECESSED into the foot, or it fouls the grid socket
//   thick deck   ->  THIN deck, because the screw must now span the whole plate
//
// THE DECK IS THE PART PEOPLE GET WRONG. At the old 12 mm, a screw entering from
// below crosses 12.75 mm of plastic before it reaches the bracket at all — it
// would need to be 17 mm long just to get 4 mm of engagement. At 5 mm the screw
// crosses 5.75 and a 10 mm screw gives 4.25 mm of bite. The deck is now sized by
// screw reach, not by breakthrough clearance.
//
// ⚠️ HEAD_D / HEAD_H ARE NOT MEASURED. Nobody has put calipers on the screw
// heads. They are set GENEROUSLY on purpose: an oversized recess loses a little
// material, an undersized one holds the plate off the grid and the latch never
// seats. Wrong in the safe direction, like the accessory bin's open bay.
//
// ⚠️ SCREW LENGTH IS STILL NOT MEASURED, and now it matters more than it did.
// Too short and it never reaches the bracket; too long and it bottoms out inside
// the bracket before the plate pulls tight. Measure it and set DECK from the
// table in the README.
//
// WHY 2×2 AND NOT 2×1. The hole pattern is only 36 × 21, which a 2×1 would take.
// But Clickfinity holds about 12.2 N per cell: a 2×1 is ~24 N (2.5 kgf) and a 2×2
// is ~49 N (5 kgf). Pulling a heat gun off a magnetic bracket beats 2.5 kgf
// easily, and then the plate lifts with the gun. Four cells, not two.
//
// ---- THE 20° RAMP (added 2026-08-31) --------------------------------------
//
// WHY: parked flat, the gun's auto-off only triggered about 45% of the time.
// Tilting it lets gravity settle the gun into the cradle instead of leaving it
// balanced. User's call on the angle and the direction: nozzle end DOWN.
//
// THE RISE RUNS ACROSS THE 21 mm SPACING, NOT THE 36. The two screws that are
// 36 mm apart sit at the SAME height — that side stays level — and the ramp
// climbs from one 21 mm row to the other. v2.1.0 shipped with this the other way
// round and tilted the bracket about the wrong axis.
//
// Only the SIGN is free: a Gridfinity plate spins 180° on the grid, so the ramp
// is cut rising along +Y and you park the plate with the nozzle at the low end.
//
// ⚠️ HOLE_X IS MEASURED ON THE BRACKET, WHICH IS NOW TILTED. 36 mm centre to
// centre is a distance along the bracket's own face; in PLAN that foreshortens
// to 36·cos20 = 33.83. Drilling at 36 apart in plan would space the holes
// 38.3 mm apart along the ramp and the bracket would not sit on them.
//
// ⚠️ THE SCREWS MUST BE NORMAL TO THE RAMP, not vertical, or they meet the
// bracket's threads at 20° and cross-thread. Both the through-bore and the head
// counterbore run along that tilted axis.
//
// THE COUNTERBORE IS WHAT KEEPS THE SCREW SHORT. Left solid, a screw entering
// the underside would cross 20.0 mm of plastic at the low hole and 33.1 mm at
// the high one — two different screw lengths, both long, and the whole reason
// DECK was thinned in the first place. The counterbore is cut along the same
// tilted axis from the bottom face up to DECK below the ramp, so the screw
// crosses DECK and nothing more, at BOTH holes. Same 10 mm screw as the flat
// version.
//
// The counterbore's seat is a disc tilted 20° at the top of an 8 mm bore, walled
// all round — that is a bridge, not a cantilevered ceiling, and it closes
// progressively from one side. It prints.
//
// PRINT: as emitted, feet down. No supports — the ramp faces UP and every bore
// closes as a bridge.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../lib/gridfinity.scad>

/* [Bracket] */
HOLE_X  = 36.0;   // measured 2026-08-20, centre to centre. ALONG the tilt axis,
                  //   so both of these sit at the same height and it is NOT
                  //   foreshortened
HOLE_Y  = 21.0;   // measured, centre to centre ON THE BRACKET FACE — this is the
                  //   pair the ramp climbs between, so this one foreshortens

/* [Ramp] */
TILT = 20;        // [0:1:35] degrees. 0 gives the old flat plate back.
// Thickness of the deck at the ramp's LOW edge. This is NOT the same number as
// DECK: DECK is what a screw crosses at a hole and is set by screw reach, while
// this is just how much plastic sits under the ramp's thin end. Keeping them
// separate is worth ~21 cm3 — at 5 the part is 163 cm3, at 2 it is 142.
RAMP_LOW = 2.0;   // [1:0.5:8]

/* [Screws — entering from BELOW] */
SCREW_OD  = 2.84;   // measured 2026-08-20 — thread outside diameter
SHANK_CLR = 0.40;   // [0.2:0.05:1] the screw must pass FREELY; this is not a pilot
SCREW_D   = SCREW_OD + SHANK_CLR;

HEAD_D = 8.0;   // [5:0.5:12] ⚠️ NOT MEASURED — deliberately generous
HEAD_H = 4.0;   // [2:0.5:4.7] ⚠️ NOT MEASURED — must stay inside the foot

/* [Plate] */
DECK = 5.0;     // [3:0.5:14] sized by SCREW REACH, not breakthrough. See header.

W     = 2*GF - 0.5;
Z_LOW = BIN_BASE_H + RAMP_LOW;          // deck top at the ramp's LOW edge
H     = Z_LOW + W*tan(TILT);            // ...and at the high edge
HOLE_Y_PLAN = HOLE_Y*cos(TILT);         // foreshortened — see header
REACH = DECK;                           // plastic the screw crosses, BOTH holes

function face_z(y) = Z_LOW + (y + W/2)*tan(TILT);

assert(HOLE_X + HEAD_D + 3 < W, "Head bores too wide for a 2x2.");
assert(HOLE_Y_PLAN + HEAD_D + 3 < W, "Head bores too deep for a 2x2.");
assert(DECK < face_z(-HOLE_Y_PLAN/2)/cos(TILT),
       "DECK exceeds the material above the LOW hole — no room for a counterbore.");
echo(str("plate ", W, " square, ", Z_LOW, " tall at the low edge and ", H,
         " at the high; ramp ", TILT, " deg; the 21 pair is ", HOLE_Y_PLAN,
         " apart in plan (", HOLE_Y, " on the bracket), the 36 pair is level",
         "; screw crosses ", REACH,
         " mm -> needs a ", REACH + 4, " mm screw"));

difference() {
    // BLANK IS CUT 1 mm PROUD OF H, and the ramp trims it back. Built exactly H
    // tall, the blank's top face and the ramp plane meet along the same line at
    // the high edge (x 41.75, z 37.14) — the cut lands ON the face it exits
    // instead of passing through it, and OpenSCAD 2021.01 returns 3 non-manifold
    // edges there. 2026.06 renders it clean. Isolated by bisection: the ramp cut
    // alone fails, the bores alone pass. The finished height is still exactly H,
    // because the ramp is what caps it.
    bin_blank(2, 2, H + 1);

    // the ramp itself — everything above a plane through the low edge at TILT
    translate([0, -W/2, Z_LOW]) rotate([TILT, 0, 0])
        translate([-W, -0.01, 0]) cube([2*W, 3*W, 3*H]);

    for (sx = [-1, 1], sy = [-1, 1]) {
        y = sy*HOLE_Y_PLAN/2;
        // bores run along the ramp's NORMAL: down and toward +Y
        translate([sx*HOLE_X/2, y, face_z(y)]) rotate([180 + TILT, 0, 0]) {
            // START 1 mm OUTSIDE THE RAMP FACE. Beginning the bore exactly at
            // face_z lands its end cap on the surface it exits, and OpenSCAD
            // 2021.01 turns that coincidence into non-manifold edges — 3 of them
            // here, plus a 3.8e-06 mm sliver. 2026.06 renders it clean, which is
            // how it would have reached CI. Same bug as the thermal mount's
            // counterbore: a cut must pass THROUGH the face it exits.
            translate([0, 0, -1])
                cylinder(d = SCREW_D, h = 2*H, $fn = 32);        // shank, through
            translate([0, 0, DECK])                              // head + driver
                cylinder(d = HEAD_D, h = 2*H, $fn = 48);
        }
    }
}
