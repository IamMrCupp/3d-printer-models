// owon_bin_tips — 2×3 block, 5 × 8 grid of bores for the DC barrel-adapter tips.
//
// Sits at the FRONT of the tray (the two rows nearest you). It is the bin you
// touch every session and the shortest one in the tray, so it goes where it
// won't be reached over — see owon_bins_common.scad.
//
// Tips stand TIP-UP: the body sits in the bore and the business end stands
// proud, so you pick one out by the part you're about to plug in rather than
// tipping the block out to see what's in it.
//
// Bore is 13.0 mm, measured off owon_tip_fit_gauge.scad — see owon_bins_common.
//
// PRINT: flat, foot-down, no supports. The bores are vertical, so there is
// nothing to bridge.

include <owon_bins_common.scad>

$fn = 48;

// TIP_BORE is already the finished hole, so clearance is passed as zero rather
// than applied twice. syringe_rack()'s asserts still guard the webs and the
// outer wall against it.
syringe_rack(2, 3, TIP_COLS, TIP_ROWS, TIP_BORE, TIP_CAPTURE, clr = 0,
             pitch_y = TIP_PITCH_Y);
