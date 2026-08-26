// owon_fit_gauge.scad — clearance gauge for the OWON tray frame. PRINT THIS FIRST.
//
// Five stubby U-channels, each a 14 mm-long slice of the frame's skirt at a
// different clearance. Prints in minutes instead of two hours, and tells you the
// one number the frame actually depends on.
//
// The v1.0.3 frame shipped with CASE_CLR = 0.40 mm — 0.20 mm per side on an
// 84.30 mm case. That is a press fit, not a drop-over: PETG shrinks ~0.4 %
// (~0.34 mm across this span) and internal dimensions print undersize on top of
// that, so the opening came out at or below the case and would not go on.
// Rather than guess a replacement, measure it.
//
// HOW TO USE
//   1. Print flat, as modelled. No supports. Same filament and profile as the
//      real frame — shrinkage is exactly what you're measuring.
//   2. Count the notches on each gauge's wall tops: 1 = tightest, 5 = loosest.
//   3. Try each over the top edge of the unit, in order.
//   4. Keep the LOOSEST one that still feels snug side-to-side — a tray of
//      adapters wants no wobble, but it has to drop on one-handed.
//   5. Tell me the notch count and I'll set CASE_CLR and re-cut the frame.
//
// If even notch 5 won't go on, the case is wider than 84.30 mm where the skirt
// sits — measure across the case 20 mm BELOW the top, at its widest (include any
// rim, seam or screw head) and give me that number instead.

include <../owon_tray_common.scad>
$fn = 32;

/* [Gauge] */
// Total added clearance for each gauge, tightest first. Notch count = index.
CLEARS     = [0.40, 0.80, 1.20, 1.60, 2.00];
GAUGE_LEN  = 14.0;   // [10:1:30] mm along the case — long enough to feel square
GAUGE_DEPT = 10.0;   // [6:1:20] mm skirt depth. Shorter than the real 20 mm
                     //   (SKIRT_D) purely to save print time; the fit is set by
                     //   the span, not the depth.
BAR_T      = 3.0;    // [2:0.5:5] mm bar joining the two walls
NOTCH      = 1.2;    // [0.8:0.1:2.0] mm notch width
GAP        = 6.0;    // [4:1:12] mm bed spacing between gauges

// One gauge: a U printed OPENING-UP (bar on the bed, walls rising), so there is
// nothing to bridge and no supports. Flip it to drop it over the case.
module gauge(clr, notches) {
    w  = CASE_W + clr;          // the clear span under test
    ow = w + 2*SKIRT_T;
    h  = BAR_T + GAUGE_DEPT;
    difference() {
        translate([-ow/2, 0, 0]) cube([ow, GAUGE_LEN, h]);
        // the opening
        translate([-w/2, -1, BAR_T]) cube([w, GAUGE_LEN + 2, GAUGE_DEPT + 1]);
        // tally notches cut into BOTH wall tops, so it reads either way up
        for (s = [-1, 1], i = [0:notches-1])
            translate([s*(w + SKIRT_T)/2 - NOTCH/2,
                       2 + i*(NOTCH + 1.4),
                       h - 0.8])
                cube([NOTCH, NOTCH, 1.2]);
    }
}

// Lay them out tightest-to-loosest along +Y.
for (i = [0:len(CLEARS)-1])
    translate([0, i*(GAUGE_LEN + GAP), 0]) gauge(CLEARS[i], i + 1);
