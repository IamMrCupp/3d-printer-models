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
// One flat plate with THROUGH holes, three rows at increasing clearance. This
// is a diameter test and nothing else — it does not tell you whether a syringe
// stands up straight, only whether it passes. That is what the real bin is for.
//
// KEEP IT. A through-hole plate at known diameters is a permanent gauge, not a
// one-shot coupon: anything cylindrical that turns up later gets sized by
// dropping it through until it stops. It joins bit_fit_gauge, owon_fit_gauge and
// scope_corner_gauge on the shelf. That is why every hole is ENGRAVED with its
// actual diameter as well as notched — a notch count only means something next
// to this file; a number means the plate explains itself in six months.
//
// It got here by trimming: a first cut with 40 mm blind bores (the flux bin's
// depth) sliced at ~5 hours; 12 mm bores at ~2 hours; a coupon that costs a
// fifth of the print it's testing is not a coupon. Caveat that comes with the
// shortcut: a deep bore reads a touch tighter than a through hole (a syringe
// leans in a shallow bore and jams in a deep one), so if a notch reads
// BORDERLINE here, go one looser for the real bin — and two looser for
// bin_uv_mask, which is 65 mm deep.
//
// HOW TO USE
//   1. Print flat, as modelled. No supports. SAME filament and profile as the
//      real bin — shrinkage is what you're measuring.
//   2. Read the diameter engraved beside each hole (or count notches: 1 = tightest).
//   3. Pass the syringe / lamp head through each hole in order.
//   4. Keep the TIGHTEST one it passes through and back out of freely — no twist,
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
// The small row has room to spare, so it carries on past the syringe question
// as a general small-cylinder ladder — pens, probes, tips, standoffs. These are
// ABSOLUTE diameters, not clearances, appended after the four syringe steps.
SMALL_EXTRA = [13, 14, 15, 16];   // trimmed from 20 — the width was costing more time than the holes were worth
PLATE_T  = 3;     // [2.5:0.5:8] mm — through holes; a hole is still a hole at 3,
                  //   and every 0.5 mm here is a whole extra skin's worth of time
D_LAMP   = 37.83; // TrixHub TH007 head — from uv_light_holder.scad
PITCH_H  = 43;    // [40:1:52] mm centre spacing, lamp-head row
PITCH_L  = 30;    // [28:1:40] mm centre spacing, large row
PITCH_S  = 20;    // [16:1:30] mm centre spacing, small row — clears the 16 mm extra
WALL     = 2.5;   // [2:0.5:5] mm web between holes and to the plate edge
NOTCH    = 1.2;   // [0.8:0.1:2] mm
LABEL_H  = 4.0;   // [3:0.5:7] mm text height for the engraved diameters
LABEL_D  = 0.6;   // [0.3:0.1:1.2] mm engrave depth — two layers at 0.3
ROW_GAP  = 2;     // [1:1:8] mm between rows

n = len(CLEARS);
h = PLATE_T;

// One row of through-holes at y. Beside each: its diameter engraved on the
// +Y side (the number you actually read), and a notch count on the -Y side
// (a fallback that survives a worn engraving). `dias` is the list of absolute
// hole diameters for the row; notches only go on the first n (the clearance
// steps), the extras are read by their label.
module hole_row(dias, pitch, y, x0) {
    for (i = [0 : len(dias) - 1]) {
        x   = x0 + i * pitch;
        dia = dias[i];
        translate([x, y, -1]) cylinder(d = dia, h = h + 2);
        // engraved diameter, one decimal, above the hole
        translate([x, y + dia/2 + 1.2, h - LABEL_D])
            linear_extrude(LABEL_D + 0.1)
                text(str(round(dia * 10) / 10), size = LABEL_H,
                     halign = "center", valign = "bottom", font = "Liberation Sans:style=Bold");
        // notch count below the hole — clearance steps only
        if (i < n) for (k = [0 : i])
            translate([x - i * (NOTCH + 0.8)/2 + k * (NOTCH + 0.8) - NOTCH/2,
                       y - dia/2 - 3.0, h - 1.0])
                cube([NOTCH, 2, 1.1]);
    }
}
function steps(d) = [for (c = CLEARS) d + c];
DIAS_H = steps(D_LAMP);
DIAS_L = steps(D_LARGE);
DIAS_S = concat(steps(D_SMALL), SMALL_EXTRA);

// One plate, three rows. Each row's width is its own hole run; the plate is
// as wide as the widest row plus margin, rows stacked in Y with the biggest at
// the back so its holes don't crowd the small ones.
row_w = function(dias, pitch) (len(dias) - 1) * pitch + max(dias);
W = max(row_w(DIAS_H, PITCH_H), row_w(DIAS_L, PITCH_L), row_w(DIAS_S, PITCH_S)) + 2 * WALL;
// Row band = biggest hole + label above (LABEL_H + gap) + notches below (~5) + web.
band = function(dias) max(dias) + LABEL_H + 1.2 + 5 + 2 * WALL;
r_H = band(DIAS_H); r_L = band(DIAS_L); r_S = band(DIAS_S);
D   = r_H + r_L + r_S + 2 * ROW_GAP;
// hole centre sits below the band centre by half the label allowance
off = (LABEL_H + 1.2 - 5)/2;
y_S = -D/2 + r_S/2 - off;
y_L = -D/2 + r_S + ROW_GAP + r_L/2 - off;
y_H = -D/2 + r_S + ROW_GAP + r_L + ROW_GAP + r_H/2 - off;

difference() {
    linear_extrude(h) offset(3) offset(-3) square([W, D], center = true);
    hole_row(DIAS_H, PITCH_H, y_H, -W/2 + WALL + DIAS_H[0]/2);
    hole_row(DIAS_L, PITCH_L, y_L, -W/2 + WALL + DIAS_L[0]/2);
    hole_row(DIAS_S, PITCH_S, y_S, -W/2 + WALL + DIAS_S[0]/2);
}
