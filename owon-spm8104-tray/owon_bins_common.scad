// owon_bins_common.scad — the bins that drop into the OWON SPM8104 top tray.
//
// The tray is a 2×5 Clickfinity plate (84 × 210, 10 cells). Two bins fill it
// exactly:
//
//     2×3  owon_bin_tips   126 mm   barrel-adapter tips, standing tip-up
//     2×2  owon_bin_cords   84 mm   mains lead, alligator leads, master plug
//
// LOW BIN AT THE FRONT. The tip block is ~16 mm tall and the cord well is 55 —
// reversed, you'd reach over a 55 mm wall to pick a 12 mm tip, and the well
// would hide the block entirely. It also buys the warning label a home: the
// cord well's front wall stands ~39 mm proud of the tip block, so a label there
// reads across the top of it from a normal bench stance.
//
// These are stock Gridfinity bins — nothing here is Clickfinity-specific. The
// latch tongues in lib/clickfinity.scad grab an unmodified bin foot, so these
// drop into either plate type (phase-2 decision #2).

include <../lib/syringe.scad>     // pulls in vessel.scad → gridfinity.scad
include <../lib/label.scad>       // include, not use — the label parts need LABEL_T

// ===========================================================================
// UNMEASURED — the one number everything below is built on
// ===========================================================================
// TIP_D is the outside diameter of an adapter tip's BODY (the part that sits
// down in the hole), not the metal barrel sticking out of it.
//
// >>> 12.0 IS A PLACEHOLDER. It has never been measured. <<<
//
// Do NOT reach for calipers to fix it. Print owon_tip_fit_gauge.scad and read
// the answer off the coupon instead — the gauge reports the *finished hole
// size* a tip actually drops into, which folds the tip's true OD and this
// printer's hole shrinkage into a single number. Measuring the tip gives you
// only half of that, and small vertical holes come off an FDM printer undersize
// by 0.15–0.3 mm in a way that is specific to the machine, nozzle and filament.
//
// Set TIP_BORE from the gauge and TIP_D/TIP_CLR stop mattering.
TIP_D   = 12.0;   // [6:0.1:16] placeholder body OD — see above
TIP_CLR = 0.60;   // slip clearance, per diameter (not per side)

// The finished hole. Once the gauge is printed, hard-set this to the winning
// size and ignore the two lines above:
//     TIP_BORE = 12.0;   // ← from the gauge, e.g. the hole marked 12.0
TIP_BORE = TIP_D + TIP_CLR;

// ---------------------------------------------------------------------------
// Tip block — 2×3
// ---------------------------------------------------------------------------
// 5 × 8 = 40 bores. The kit is 41 tips, so this is one short on purpose: the
// fat proprietary tips (Dell / HP / Lenovo) are the ones most likely to bust
// the pitch, and the odd one out rides in the cord well next to the master
// plug it pairs with.
//
// Both counts are parametric because they are downstream of TIP_BORE, and
// syringe_rack() asserts on them: at 2×3 the auto-pitch is 16.80 across and
// 15.75 deep, so a bore over ~13.3 mm makes 8 rows fail at render time rather
// than on the printer. If that assert fires, drop TIP_ROWS to 7 (35 slots) —
// don't silence it.
TIP_COLS = 5;
TIP_ROWS = 8;

// Capture depth, NOT tip length. Tips must stand proud enough to pluck with
// finger and thumb — that is the whole point of storing them tip-up — so this
// is deliberately shallow. A tip that sinks flush is a tip you fish out with
// tweezers.
TIP_CAPTURE = 10.0;   // [6:0.5:20]

// ---------------------------------------------------------------------------
// Cord well — 2×2
// ---------------------------------------------------------------------------
// 55 mm total (≈49 mm of usable depth). Deep enough that a coiled lead stays
// coiled: a shallow open pocket lets the coil spring itself out, which is the
// same failure the uv-mask-station cord well was called out for.
CORD_H = 55.0;   // [30:1:80] total bin height, foot included

// One divider, splitting front-to-back into two ~84 × 40 compartments.
//
// The rear compartment is for the master barrel cord — the harvested plug lead.
// Every tip in the kit is female, so without that one cable the entire set
// connects to nothing. It gets its own compartment rather than living loose in
// the bulk, which is exactly how a single point of failure goes missing.
//
// Set CORD_ROWS = 1 for one undivided 84 × 84 well if the mains lead turns out
// not to coil happily into 84 × 40. That is a physical question, so it is left
// as a knob rather than guessed at.
CORD_ROWS = 2;

// 2.0 mm rather than the 1.2 mm default. Two reasons, and the second is the
// real one: a 55 mm wall around a bulk-storage bin wants the stiffness, and the
// warning label below is a 0.8 mm pocket cut into this wall — at 1.2 mm that
// leaves 0.4 mm behind the text, which is a single perimeter and a light leak.
// At 2.0 mm it leaves 1.2 mm. Costs 1.6 mm of interior width on 84.
CORD_WALL = 2.0;

// ---------------------------------------------------------------------------
// Warning label — two-colour inset, on the cord well's front wall
// ---------------------------------------------------------------------------
// phase-2 §C.1 suggested "19 V — METER CENTRE PIN BEFORE CONNECTING". The
// voltage is dropped here: the SPM8104 is an adjustable supply, so a number
// silkscreened onto the bin would be wrong the moment the dial moves, and a
// warning that is sometimes wrong gets ignored. What survives is the action.
WARN_L1 = "CHECK V + POLARITY";
WARN_L2 = "METER THE CENTRE PIN";
WARN_SIZE = 4.0;      // [3:0.5:8]
WARN_Z1   = 42.0;     // label baselines, measured up the front wall. Both sit
WARN_Z2   = 34.0;     //   above the 16 mm tip block so they stay readable.

// Derived — the cord well's outer front face (bin block is nx*GF − 0.5).
CORD_FRONT_Y = -(2*GF - 0.5)/2;
