// plate_iron_stand — 2×5 plate that anchors the soldering iron / desoldering gun
// stand to the grid.
//
// HOW YOU USE IT:
//   The plate latches into the desk grid. Drop the stand straight down into the
//   channel — tapered rails down both sides, a lip across the front and another
//   across the rear. It is boxed in on all four sides. Lift it straight out.
//
// RAILS AND LIPS, NOT A POCKET — and this is the whole point. The base is 70
// across the front, 65 across the rear, 175 long, and the sponge end is a
// LARGE-RADIUS D that three numbers cannot describe. A close-fitting pocket
// would need that radius, and getting it wrong means the stand never drops in.
//
// A LIP DOES NOT NEED THE RADIUS. It is a backstop, not a socket: a straight bar
// across the rear meets the D at its apex and stops it there, and it does not
// care what the curve does on either side of that point. So the part gets its
// front and back without anyone tracing anything.
//
// END CLEARANCE IS DELIBERATELY LOOSE. The 175 is approximate and the D apex may
// sit past it, so END_CLR is 3.0 against the sides' 1.0. That leaves ~6 mm of
// fore-aft float, which is fine because THE LIPS ARE NOT WHAT LOCATES THE STAND
// — the converging rails are. It wedges between them and stops. The lips catch
// it if it is knocked, and stop a hard shove walking it off the deck.
//
// The rails run the full span and go PARALLEL for the last 3 mm at each end,
// rather than extrapolating the taper past the stand. Extrapolating would pinch
// the rear gap below 67 and bind the very thing the taper is meant to seat.
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
LENGTH  = 175.0;  // measured, approximate — see END_CLR
CLR     = 1.0;    // [0.5:0.1:3] per side, on the taper. Small: it wants to wedge.
END_CLR = 3.0;    // [1:0.5:8] per end. Larger, because LENGTH is approximate and
                  //   the D apex may sit past it.

/* [Plate] */
NX = 2; NY = 5;
DECK    = 2.4;    // [1.6:0.2:6] plate thickness under the stand
RAIL_H  = 7.0;    // [4:0.5:15] rail height above the deck
RAIL_T  = 3.0;    // [2:0.5:6] rail thickness
LIP_H   = RAIL_H; // [4:0.5:15] end lip height — matches the rails by default
LIP_T   = 3.0;    // [2:0.5:6] end lip thickness

H    = BIN_BASE_H + DECK;
W    = NX*GF - 0.5; D = NY*GF - 0.5;
IW   = W - 2*1.2;   ID = D - 2*1.2;
SPAN = LENGTH + 2*END_CLR;         // clear opening between the two lips

// Half-gap at a given y, interpolating the taper front (-) to rear (+).
// CLAMPED to the stand's own length: past either end the rails run parallel.
function halfgap(y) =
    let (yc = max(-LENGTH/2, min(LENGTH/2, y)))
    ((FRONT_W + (REAR_W - FRONT_W) * (yc + LENGTH/2) / LENGTH) + 2*CLR) / 2;

function lipw(sgn) = 2*halfgap(sgn*LENGTH/2) + 2*RAIL_T;

assert(FRONT_W + 2*CLR + 2*RAIL_T <= IW,
       str("Rails + stand (", FRONT_W + 2*CLR + 2*RAIL_T, ") exceed the ", IW, " interior."));
assert(SPAN + 2*LIP_T <= ID,
       str("Stand + end lips (", SPAN + 2*LIP_T, ") exceed the ", ID,
           " interior. Lengthen the plate or drop END_CLR."));
assert(lipw(-1) <= IW && lipw(1) <= IW, "An end lip is wider than the interior.");
echo(str("plate ", W, " x ", D, " x ", H + RAIL_H,
         "; gap ", 2*halfgap(-LENGTH/2), " front -> ", 2*halfgap(LENGTH/2), " rear",
         "; lips ", SPAN, " apart"));

module rail() {
    translate([0, 0, H]) linear_extrude(RAIL_H)
        polygon([
            [halfgap(-SPAN/2),            -SPAN/2  ],
            [halfgap(-LENGTH/2),          -LENGTH/2],
            [halfgap( LENGTH/2),           LENGTH/2],
            [halfgap( SPAN/2),             SPAN/2  ],
            [halfgap( SPAN/2)   + RAIL_T,  SPAN/2  ],
            [halfgap( LENGTH/2) + RAIL_T,  LENGTH/2],
            [halfgap(-LENGTH/2) + RAIL_T, -LENGTH/2],
            [halfgap(-SPAN/2)   + RAIL_T, -SPAN/2  ],
        ]);
}

module lip(sgn) {
    gw = lipw(sgn);
    translate([-gw/2, sgn > 0 ? SPAN/2 : -SPAN/2 - LIP_T, H])
        cube([gw, LIP_T, LIP_H]);
}

union() {
    bin_blank(NX, NY, H);
    rail();
    mirror([1, 0, 0]) rail();
    lip(-1);
    lip( 1);
}
