// syringe_fit_gauge.scad — bore-fit gauge for every cylinder-in-a-bore part on
// the bench. PRINT THIS BEFORE bin_flux, bin_uv_mask and uv_light_holder.
//
// All three hold a measured cylinder in a bore of (diameter + CLR), and NONE has
// ever been fit-tested through this printer. Hole shrinkage is exactly the
// thing calipers can't tell you — the OWON tip block already taught this: the
// gauge read 13.0 where the barrel measured 12.
//
//   bin_flux          30 cc barrel 25.5 → bore 26.5;   10 cc barrel 10.8 → 11.8
//   bin_uv_mask       10 cc barrel 10.8 → bore 11.8   (same family, 65 mm deep)
//   uv_light_holder   lamp head 37.83   → bore 38.83  (self-centres on the head,
//                                          so a tight bore JAMS, not leans)
//
// Three staircases, one per family, each a row of blind bores at increasing
// clearance. Bores are GAUGE_DEPTH deep, deliberately shallower than any real
// bin: this is a diameter test, and 12 mm is plenty to feel a fit and stand a
// syringe up. A first cut at CAPTURE (40 mm) depth sliced at ~5 hours, which is
// no coupon at all. Caveat that comes with the shortcut: a deep bore reads a
// touch tighter than a shallow one (a syringe leans in a shallow bore, jams in a
// deep one), so if a notch reads BORDERLINE here, go one looser for the real
// bin — and two looser for bin_uv_mask, which is 65 mm deep.
//
// HOW TO USE
//   1. Print flat, as modelled. No supports. SAME filament and profile as the
//      real bin — shrinkage is what you're measuring.
//   2. Count the notches on the rim beside each bore: 1 = tightest.
//   3. Drop the syringe into each bore in order.
//   4. Keep the TIGHTEST one it drops into and lifts out of freely — no twist,
//      no push. A rack you have to fight to load gets left loaded.
//   5. Tell me the notch count for each of the three rows and I'll set CLR (or
//      a per-family clearance) and re-cut whichever bins need it.
//
// The released bins use CLR = 1.0, which sits BETWEEN notches 2 and 3 here.
// If notch 2 (0.7) already drops in and lifts out freely, the bins print fine
// as released. If it takes notch 3 or 4, tell me which.

include <../syringe_holders_common.scad>
$fn = 48;

/* [Gauge] */
// Total added clearance per bore (on diameter), tightest first. Notch = index.
CLEARS   = [0.4, 0.7, 1.3, 1.6];   // 1.0 (what the bins ship with) sits between 2 and 3
GAUGE_DEPTH = 12;  // [8:1:20] mm — a diameter test, not a depth test
D_LAMP   = 37.83; // TrixHub TH007 head — from uv_light_holder.scad
PITCH_H  = 45;    // [40:1:52] mm centre spacing, lamp-head row
PITCH_L  = 32;    // [28:1:40] mm centre spacing, large row
PITCH_S  = 17;    // [14:1:24] mm centre spacing, small row
WALL     = 2.0;   // [1.2:0.2:4] mm material outboard of the outermost bore
FLOOR    = 1.4;   // [1:0.2:3] mm under each bore
NOTCH    = 1.2;   // [0.8:0.1:2] mm
ROW_GAP  = 6;     // [4:1:12] mm between the two staircases

n = len(CLEARS);
h = FLOOR + GAUGE_DEPTH;

module staircase(d, pitch, y) {
    W = (n - 1) * pitch + d + 1.6 + 2 * WALL;
    D = d + 1.6 + 2 * WALL;
    translate([0, y, 0]) difference() {
        // block, corners rounded so it sits flat and doesn't catch
        linear_extrude(h) offset(3) offset(-3) square([W, D], center = true);
        for (i = [0 : n - 1]) {
            x = -W/2 + WALL + (d + 1.6)/2 + i * pitch;
            translate([x, 0, FLOOR]) cylinder(d = d + CLEARS[i], h = h);
            // notches on the +Y rim, count = i + 1
            for (k = [0 : i])
                translate([x - i * (NOTCH + 0.8)/2 + k * (NOTCH + 0.8) - NOTCH/2,
                           D/2 - 1.5, h - 1.0])
                    cube([NOTCH, 2, 1.1]);
        }
    }
}

// Three rows, biggest at the back so nothing crowds. Y positions stack the
// row depths plus gaps.
D_H = D_LAMP  + 1.6 + 2 * WALL;
D_L = D_LARGE + 1.6 + 2 * WALL;
D_S = D_SMALL + 1.6 + 2 * WALL;
y_L = 0;
y_H = y_L + D_L/2 + ROW_GAP + D_H/2;
y_S = y_L - D_L/2 - ROW_GAP - D_S/2;
staircase(D_LAMP,  PITCH_H, y_H);
staircase(D_LARGE, PITCH_L, y_L);
staircase(D_SMALL, PITCH_S, y_S);
