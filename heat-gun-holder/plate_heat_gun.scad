// plate_heat_gun — 2×2 Gridfinity plate that the heat gun's magnetic bracket
// bolts to FROM BELOW.
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
// PRINT: as emitted, feet down. No supports — every hole is vertical.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../lib/gridfinity.scad>

/* [Bracket] */
HOLE_X  = 36.0;   // measured 2026-08-20, centre to centre — a true rectangle
HOLE_Y  = 21.0;   // measured, centre to centre

/* [Screws — entering from BELOW] */
SCREW_OD  = 2.84;   // measured 2026-08-20 — thread outside diameter
SHANK_CLR = 0.40;   // [0.2:0.05:1] the screw must pass FREELY; this is not a pilot
SCREW_D   = SCREW_OD + SHANK_CLR;

HEAD_D = 8.0;   // [5:0.5:12] ⚠️ NOT MEASURED — deliberately generous
HEAD_H = 4.0;   // [2:0.5:4.7] ⚠️ NOT MEASURED — must stay inside the foot

/* [Plate] */
DECK = 5.0;     // [3:0.5:14] sized by SCREW REACH, not breakthrough. See header.

H = BIN_BASE_H + DECK;
REACH = (BIN_BASE_H - HEAD_H) + DECK;   // plastic the screw crosses

assert(HEAD_H < BIN_BASE_H - 0.5,
       "Head recess would cut through the foot into the deck.");
assert(HOLE_X + HEAD_D + 3 < 2*GF - 0.5, "Head recesses too wide for a 2x2.");
echo(str("plate ", 2*GF - 0.5, " square x ", H, " tall; ", SCREW_D,
         " through, head recess ", HEAD_D, " x ", HEAD_H,
         "; screw crosses ", REACH, " mm -> needs a ", REACH + 4, " mm screw"));

difference() {
    bin_blank(2, 2, H);
    for (sx = [-1, 1], sy = [-1, 1]) {
        // clearance hole, all the way through
        translate([sx*HOLE_X/2, sy*HOLE_Y/2, -0.1])
            cylinder(d = SCREW_D, h = H + 0.2, $fn = 32);
        // head recess, cut UP from the underside — stays inside the foot
        translate([sx*HOLE_X/2, sy*HOLE_Y/2, -0.1])
            cylinder(d = HEAD_D, h = HEAD_H + 0.1, $fn = 48);
    }
}
