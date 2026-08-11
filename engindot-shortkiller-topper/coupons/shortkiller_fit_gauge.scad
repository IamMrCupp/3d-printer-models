// shortkiller_fit_gauge — PRINT THIS FIRST, AND ONLY THIS. A measuring coupon.
//
// It reads TWO numbers, both of which are currently guesses, and both of which
// have to be right before any real part is worth filament:
//
//   A. The SHORTKILLER's width  -> sets SK_W, and NX_CRADLE via the 42 mm grid
//   B. The ENGINDOT lid's width -> sets GX, i.e. how wide the plate can be
//
// Same tool, same procedure for both:
//   1. Print flat. No supports, low infill, any material — it's a coupon.
//   2. Hold the tall solid stop flush against ONE side of the case.
//   3. Look along the staircase to the other side of the case.
//   4. The LAST step the case reaches past is the width in mm. Steps are
//      engraved. Between two steps -> report the smaller one.
//
// Range spans 70–150 because the honest uncertainty is that wide: the OWON's
// measured lid is 84.30 and the ENGINDOT is reportedly smaller, but the earlier
// photo estimate of the Shortkiller was 110. Those cannot all be true. One
// print settles it.
include <../shortkiller_common.scad>
use <../../lib/label.scad>

WIDTHS  = [for (w = [70 : 5 : 150]) w];
LANE    = 6.0;    // per-step lane width
STOP_T  = 4.0;    // fixed-stop thickness
STOP_H  = 11.0;   // stop / step height — tall enough to catch a case side
STEP_T  = 4.0;    // staircase block thickness. MUST stay under the 5 mm width
                  //   pitch — at exactly 5 mm, neighbouring steps meet edge-to-
                  //   edge and the mesh goes non-manifold.
PLATE_T = 4.0;
LBL_ZONE= 18.0;   // engraved-number strip beyond the staircase

PLATE_W = LANE * len(WIDTHS);
PLATE_L = STOP_T + WIDTHS[len(WIDTHS)-1] + STEP_T + LBL_ZONE;

module gauge() {
    difference() {
        union() {
            cube([PLATE_L, PLATE_W, PLATE_T]);              // base plate
            cube([STOP_T, PLATE_W, STOP_H]);                // fixed reference stop

            for (i = [0 : len(WIDTHS)-1])                   // staircase
                translate([STOP_T + WIDTHS[i], i * LANE, 0])
                    cube([STEP_T, LANE, STOP_H]);
        }

        for (i = [0 : len(WIDTHS)-1])                       // engraved widths
            translate([PLATE_L - LBL_ZONE/2, i * LANE + LANE/2, PLATE_T])
                label_pocket(str(WIDTHS[i]), size = 4.0);
    }
}

gauge();
