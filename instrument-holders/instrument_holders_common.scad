// instrument_holders_common — shared numbers for the bench instrument docks.
//
// These are DOCKS, not storage. The DSLogic and the T48 keep USB cables run
// permanently to the computer, so each body bin has a NOTCH in its rear wall
// and the cable dresses away. Nothing coils up inside.
//
// Measured 2026-08-16 (survey/MEASUREMENTS.md), all confidence ✅:
//
//   DSLogic Plus          74 x  79 x  9
//   XGecu T48             66 x 107 x 37
//   T48 adapter block     73 x 103 x 30   (as a unit, IN its foam)
//   FNIRSI LCR-P1         65 x  87 x 27
//
// Two earlier readings were wrong and are superseded: T48 width 88.69 (really
// 66 — and that error had already produced a "needs a flared body" conclusion
// that was simply void), and DSLogic depth ~70 (really 79, off a glared
// display). Both are struck through in MEASUREMENTS.md rather than deleted.
//
// SIZING: every body bin is 2x3. Not the tightest packing — the user asked for
// breathing room, which killed two workarounds at once (a flared 2x2 for the
// LCR-P1, and a 1 mm-per-side squeeze on the DSLogic). One footprint for four
// instruments also means they are interchangeable on the grid.
include <../lib/gridfinity.scad>

$fn = 48;

/* [Cord notch] */
// Cut into the REAR wall (+Y) of the bins whose instrument stays plugged in.
//
// Deliberately narrower than a USB overmould: the cable feeds down into the
// slot, and the connector then cannot pull back through it. A sideways tug
// lands on the bin instead of dragging the instrument round its pocket — which
// matters most for the DSLogic, 9 mm tall and almost weightless.
//
// UNCONFIRMED: no cable was measured. 10 mm passes a typical USB-A/C lead and
// stops its overmould. Widen if a cable won't seat.
NOTCH_W = 10;    // [6:0.5:20]
NOTCH_D = 12;    // [4:1:30]  depth down from the rim

/* [Interior heights] */
// Bin height h relates to usable interior as: interior = h - BIN_BASE_H - floor
// (= h - 6.15 at the default 1.4 mm floor). The numbers below are chosen so the
// rim clears the instrument by a few mm without burying it.
H_DSLOGIC   = 18;   // 9 tall — open front does the lifting, not rim height
H_T48       = 34;   // 37 tall, socket face proud of the rim
H_ADAPTERS  = 30;   // 30 tall foam block, grippy enough to pinch out
H_LCR_P1    = 26;   // 27 tall
H_T48_TOOLS = 28;   // extractor tools lie flat
H_DSLOGIC_KIT = 51; // coiled harness needs real volume
H_LCR_KIT   = 31;

// A plain bin with its FRONT (-Y) wall swept away, so a front-facing connector
// panel stays reachable while the instrument sits docked.
//
// The opening is made by hulling the cavity profile with a copy of itself
// translated -D, exactly as lib's _stack_pocket does. That matters: cutting the
// front with a second solid puts the cutter's side walls onto the cavity's own
// walls, and coincident walls are what leave the sliver triangles documented on
// _bin_foot. Sweeping one profile means there is only ever one wall to be on.
//
// Local rather than in lib/ on purpose — the repo's rule is that a shared module
// earns its place at two consumers. Promote it if a second model wants one.
module open_front_bin(nx, ny, h, wall = 1.2, floor = 1.4) {
    W = nx*GF - 0.5; D = ny*GF - 0.5;
    iw = W - 2*wall; id = D - 2*wall; r = BIN_R - wall;
    difference() {
        bin_blank(nx, ny, h);
        translate([0, 0, BIN_BASE_H + floor]) linear_extrude(h)
            hull() {
                offset(r) offset(-r) square([iw, id], center = true);
                translate([0, -D]) offset(r) offset(-r) square([iw, id], center = true);
            }
    }
}

// Slot down through the rear (+Y) wall for a cable that stays connected.
// Cut wider than the wall in Y so neither face of the cutter lands on a wall
// face; same reasoning as the swept front above.
module rear_cord_notch(nx, ny, h, w = NOTCH_W, d = NOTCH_D) {
    D = ny*GF - 0.5;
    translate([-w/2, D/2 - 4, h - d]) cube([w, 8, d + 1]);
}
