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
// MEASURED — from owon_tip_fit_gauge.scad, printed 2026-08-01
// ===========================================================================
// The gauge read a MIX of 12 and 13: some tips fall through the 13 and seat
// nicely in the 12, others won't enter the 12 at all and seat nicely in the 13.
// Two populations, and the tips were gauged FEMALE-END-DOWN — which is the way
// they stand in the block, male barrel up where you can grab it.
//
// One bore size for both, at the LARGER reading. Three reasons:
//
//  1. "Falls through the 13" is an artefact of the gauge, which is drilled
//     through so a stuck tip can be pushed back out. The block's bores are
//     blind, so a 12-class tip in a 13 bore doesn't fall anywhere — it sits
//     with ~0.5 mm of radial slop.
//  2. That slop is ~5° of lean in a 10 mm bore. Invisible in a block of forty.
//  3. Mixed bores would mean counting the two populations and then remembering
//     which region of the block takes which tip. One size means any tip goes in
//     any hole, which is the whole point of an indexed block.
//
// If the lean does turn out to bother you, the fix is a deeper TIP_CAPTURE, not
// a second bore size.
TIP_BORE = 13.0;

// ---------------------------------------------------------------------------
// Tip block — 2×3
// ---------------------------------------------------------------------------
// 5 × 8 = 40 bores. The kit is 41 tips, so this is one short on purpose: the
// fat proprietary tips (Dell / HP / Lenovo) are the ones most likely to bust
// the pitch, and the odd one out rides in the cord well next to the master
// plug it pairs with.
//
// Both counts are parametric because they are downstream of TIP_BORE, and
// syringe_rack() asserts on them.
TIP_COLS = 5;
TIP_ROWS = 8;

// Explicit row pitch, and it is load-bearing. A 13 mm bore at 8 rows only fits
// inside a narrow window:
//
//   >= 15.40   syringe_rack()'s pitch assert: bore + 2*min_wall.
//   <= 15.73   collar_cup_multi()'s edge assert. The auto-pitch (15.75) spreads
//              rows evenly across the block, pushing the outermost centre to
//              55.13 and leaving 1.13 mm of outer wall — just under the 1.2 mm
//              floor. The default misses by 0.02 mm.
//
// 15.5 sits mid-window: 2.5 mm webs between bores, 2.0 mm of outer wall. Note
// the two asserts pull in OPPOSITE directions here, so this is not a number to
// nudge casually — widen the bore and the window closes entirely, at which
// point drop TIP_ROWS to 7 (35 slots) rather than shaving min_wall.
TIP_PITCH_Y = 15.5;

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
