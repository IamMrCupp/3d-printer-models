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
// ⚠ STILL UNMEASURED — no cable has been put on calipers. 10 mm is a guess that
// passes a typical USB-A/C lead. This is the same class of number that shipped a
// 10.8 mm syringe bore for an 18.8 mm syringe; treat it as a blocker, not a
// default, and measure the overmould across its widest face before printing.
NOTCH_W = 10;    // [6:0.5:20]
NOTCH_D = 12;    // [4:1:30]  depth down from the rim

// Port offset from each instrument's centreline along the rear wall, +X right
// as viewed from the front. Measure to the CENTRE of the port opening.
//
// MEASURED 2026-08-19 with coupons/t48_port_gauge.scad: the T48's USB port sits
// 10 mm off the device centreline. The bin's slot is 10 mm wide and was cut dead
// centre, spanning -5 to +5 — so the port sat at or past the slot's edge, which
// is what dragged the lead against the wall.
//
// SIGN: negative is toward the POW/RUN LED end, positive toward the `IC` arrow.
// The magnitude is measured; confirm the SIDE against the physical part before
// printing, because a sign error here is a 20 mm miss, worse than the original.
T48_NOTCH_X     = -10.0;  // measured, 10 mm off centre
DSLOGIC_NOTCH_X = 0;      // ✅ VERIFIED 2026-08-19 — printed, device seats and the
                          //   centred slot works. Its port really is centred, unlike the T48's.
NOTCH_X_MEASURED = true;   // both docks confirmed against printed parts

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

// open_front_bin moved to lib/gridfinity.scad on 2026-08-20 — it earned its
// place there on a second consumer (the cleaning station's swab bin).


// Slot down through the rear (+Y) wall for a cable that stays connected.
// Cut wider than the wall in Y so neither face of the cutter lands on a wall
// face; same reasoning as the swept front above.
// x_off shifts the slot along the rear wall, +X to the right when you are
// looking at the bin from the front. It is NOT decorative: a port sitting off
// the instrument's centreline pulls the lead sideways against the wall, which
// is what a centred slot did to the T48.
//
// ⚠ Each caller must pass its own measured x_off. The default of 0 is centred,
// which is correct only for an instrument whose port is genuinely centred —
// verify before relying on it rather than inheriting it.
module rear_cord_notch(nx, ny, h, w = NOTCH_W, d = NOTCH_D, x_off = 0) {
    if (!NOTCH_X_MEASURED)
        echo(str("WARNING: cord notch cut at x_off=", x_off,
                 " from an UNMEASURED port position. The T48's USB is off centre; ",
                 "a centred slot drags the lead against the wall. Do not print."));
    D = ny*GF - 0.5;
    W = nx*GF - 0.5;
    assert(abs(x_off) + w/2 <= W/2 - 2,
           str("Cord notch runs off the rear wall: x_off ", x_off, " with w ", w,
               " needs ", abs(x_off) + w/2 + 2, " mm of half-wall, have ", W/2, "."));
    translate([x_off - w/2, D/2 - 4, h - d]) cube([w, 8, d + 1]);
}
