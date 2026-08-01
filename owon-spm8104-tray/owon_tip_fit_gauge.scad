// owon_tip_fit_gauge — PRINT THIS FIRST. A calibration coupon, not a bench part.
//
// Eight through-holes, 8 → 15 mm, each engraved with its modelled diameter.
// Prints in minutes and answers the one question the 40-hole tip block is
// built on.
//
// WHY A COUPON INSTEAD OF CALIPERS
//   Calipers give you the tip's outside diameter. That is not the number you
//   need. Small vertical holes come off an FDM printer undersize — inner
//   perimeters over-extrude into the bore — typically by 0.15–0.3 mm, and how
//   much is specific to this printer, nozzle and filament. So the useful
//   quantity is the *modelled* hole diameter that a real tip drops into on this
//   machine, which folds both effects into one reading. Get that wrong and you
//   find out 40 holes at a time.
//
// HOW TO USE
//   1. Print flat, as modelled. No supports. Same filament and profile you will
//      use for the tip block — shrinkage is part of what you're measuring.
//   2. Try a tip in each hole, smallest first.
//   3. Keep the SMALLEST hole the tip drops into under its own weight. Tips get
//      plucked one-handed off a bench; a tip you have to wiggle out is worse
//      than one that rattles slightly.
//   4. Check a FAT proprietary tip too (Dell / HP / Lenovo are the outliers) —
//      the block is pitched for one bore size and the widest tip sets it.
//   5. Tell me the number and I'll set TIP_BORE in owon_bins_common.scad.
//
// The holes go all the way through on purpose: a tip that wedges in a blind
// hole is a coupon you have to break, and pushing it back out with a pen is
// also how you'll clear the real block.
//
// If even 15 mm is too tight, say so — the block's auto-pitch (15.75 mm deep at
// 8 rows) can't carry a bore much past 13.3 mm anyway, so a genuinely fatter
// tip changes the row count, not just the diameter.

use <../lib/label.scad>

$fn = 48;

SIZES     = [8, 9, 10, 11, 12, 13, 14, 15];
PITCH     = 18;      // [14:1:24] mm between hole centres
PLATE_H   = 12;      // [8:1:20] mm — deep enough to feel square, not to waste time
HOLE_Y    =  6;      // hole centre, forward of the label row
LABEL_Y   = -9;      // engraved size, below each hole
LABEL_SZ  = 4.5;

PLATE_W = len(SIZES) * PITCH + 8;
PLATE_D = 30;

difference() {
    translate([-PLATE_W/2, -PLATE_D/2, 0]) cube([PLATE_W, PLATE_D, PLATE_H]);
    for (i = [0 : len(SIZES)-1]) {
        x = (i - (len(SIZES)-1)/2) * PITCH;
        translate([x, HOLE_Y, -0.1])
            cylinder(d = SIZES[i], h = PLATE_H + 0.2);
        translate([x, LABEL_Y, PLATE_H])
            label_pocket(str(SIZES[i]), size = LABEL_SZ);
    }
}
