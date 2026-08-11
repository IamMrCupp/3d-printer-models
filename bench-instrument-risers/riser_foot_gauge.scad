// riser_foot_gauge.scad — foot-pocket gauge for the scope riser. PRINT THIS FIRST.
//
// A strip of six BLIND pockets, 10 mm to 20 mm, each at the riser's real pocket
// depth. Prints in minutes and settles the one number the top plate depends on.
//
// WHY A GAUGE AND NOT CALIPERS
//   The useful number is not the foot's diameter — it is the finished pocket a
//   foot actually drops into, which folds the foot's own size, its rubber
//   compliance, and this printer's hole shrinkage into a single reading.
//   Calipers give you one of those three. This is the same reasoning that set
//   the OWON barrel-tip bore, where calipers and the gauge disagreed and the
//   gauge was right.
//
// WHY THE POCKETS ARE BLIND
//   The OWON tip gauge used through-holes, and a tip "falling through the 13"
//   read as too loose when the real bores were blind and held it fine. A blind
//   pocket is what the riser actually has, so that is what this tests.
//
// HOW TO USE
//   1. Print flat, as modelled. No supports. SAME filament and profile as the
//      real blocks — shrinkage is exactly what you are measuring.
//   2. Count the notches beside each pocket: 1 = 10 mm, then +2 mm per notch.
//   3. Tip the scope up and try its foot in each pocket, smallest first.
//   4. Keep the SMALLEST pocket the foot seats into without being forced. The
//      pocket only has to stop the scope creeping — it is not a clamp, and a
//      foot you have to push in is a scope you have to fight to lift off.
//   5. Tell me the notch count and I will set FOOT_D.
//
//   While the scope is tipped up, this is also the moment to get FOOT_SPAN_X and
//   FOOT_SPAN_Y — centre to centre, both directions. Those two plus this reading
//   are the entire input to the blocks.
//
// If the foot is bigger than the 20 mm pocket, or is a long rubber strip rather
// than a round foot, stop and tell me — a strip foot wants a slot, not a bore,
// and that is a different top plate.

include <riser_common.scad>

/* [Gauge] */
DIAMS   = [10, 12, 14, 16, 18, 20];  // pocket diameters, smallest first
BASE_T  = 1.60;   // [1:0.2:3] mm solid material under each blind pocket
PITCH   = 28.0;   // [24:1:40] mm spacing along the strip
GAUGE_W = 34.0;   // [26:1:50] mm strip width
NOTCH   = 1.20;   // [0.8:0.1:2] mm notch width
NOTCH_P = 2.60;   // [2:0.1:4] mm notch spacing
NOTCH_D = 1.00;   // [0.6:0.1:2] mm notch depth

// Pockets sit toward the back of the strip; the front band carries the tally.
_pocket_y = GAUGE_W - 14.0;
_len      = len(DIAMS) * PITCH;
_h        = BASE_T + POCKET_H;

difference() {
    cube([_len, GAUGE_W, _h]);

    for (i = [0 : len(DIAMS) - 1]) {
        cx = i * PITCH + PITCH / 2;

        // the blind pocket itself — depth matches the real top plate
        translate([cx, _pocket_y, BASE_T])
            cylinder(h = POCKET_H + 0.01, d = DIAMS[i]);

        // tally notches: i+1 of them, cut into the front band
        for (n = [0 : i])
            translate([cx - ((i + 1) * NOTCH_P - NOTCH) / 2 + n * NOTCH_P,
                       3.0,
                       _h - NOTCH_D])
                cube([NOTCH, 4.0, NOTCH_D + 0.01]);
    }
}
