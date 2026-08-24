// plate_iron_stand — 2×5 plate that anchors the soldering iron / desoldering gun
// stand to the grid.
//
// HOW YOU USE IT:
//   The plate latches into the desk grid. Slide the stand in from the front,
//   between two angled rails. It wedges and stops. Lift it straight out to remove.
//
// RAILS, NOT A POCKET — and this is the whole point. The base is 70 across the
// front, 65 across the rear, 175 long, and the sponge end is a LARGE-RADIUS D
// that three numbers cannot describe. A close-fitting pocket would need that
// radius, and getting it wrong means the stand will not drop in.
//
// Locating on the STRAIGHT SIDES only sidesteps it. The taper itself stops
// fore-aft movement — the stand wedges between converging rails — and both ends
// stay open, so the D never has to be known. Fewer measurements, and the ones
// used are the ones actually taken.
//
// THE PRINTED PART TAKES NO HEAT. The stand's own cradle holds the iron; this
// only stops the stand wandering. Ordinary filament is fine.
//
// PRINT: as emitted, feet down. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../lib/gridfinity.scad>

/* [Stand base] */
FRONT_W = 70.0;   // measured 2026-08-20 — widest, at the front
REAR_W  = 65.0;   // measured — narrowest, at the rear
LENGTH  = 175.0;  // measured, approximate. Only sets how long the rails run.
CLR     = 1.0;    // [0.5:0.1:3] per side. Small: the taper wants to wedge.

/* [Plate] */
NX = 2; NY = 5;
DECK    = 2.4;    // [1.6:0.2:6] plate thickness under the stand
RAIL_H  = 7.0;    // [4:0.5:15] rail height above the deck
RAIL_T  = 3.0;    // [2:0.5:6] rail thickness

H  = BIN_BASE_H + DECK;
W  = NX*GF - 0.5; D = NY*GF - 0.5;
IW = W - 2*1.2;   ID = D - 2*1.2;
RL = min(LENGTH, ID - 4);          // rails can't run past the interior

assert(FRONT_W + 2*CLR + 2*RAIL_T <= IW,
       str("Rails + stand (", FRONT_W + 2*CLR + 2*RAIL_T, ") exceed the ", IW, " interior."));
echo(str("plate ", W, " x ", D, " x ", H + RAIL_H, "; rails ", RL,
         " long, gap ", FRONT_W + 2*CLR, " front -> ", REAR_W + 2*CLR, " rear"));

// Half-gap at a given y, interpolating the taper front (-) to rear (+).
function halfgap(y) =
    ((FRONT_W + (REAR_W - FRONT_W) * (y + RL/2) / RL) + 2*CLR) / 2;

module rail(side) {
    // a tapered wall: inner face follows the stand, outer face parallel to it
    hull() {
        translate([side * halfgap(-RL/2), -RL/2, H])
            cube([RAIL_T * side, 0.01, RAIL_H], center = false);
        translate([side * halfgap(RL/2), RL/2 - 0.01, H])
            cube([RAIL_T * side, 0.01, RAIL_H], center = false);
    }
}

union() {
    bin_blank(NX, NY, H);
    rail(1);
    mirror([1, 0, 0]) rail(1);
}
