// wrap_test_bands — four wrap bands at bracketed heights. A test coupon.
//
// Answers "can a frame wrap the Shortkiller", and settles SK_H at the same
// time, without you measuring anything.
//
// Each band is an inverted-U slice of a wrapping frame: top bar + two legs,
// open at the bottom, at the SAME 101 mm pocket width the cradle bin uses (now
// confirmed by the test fit). Only the HEIGHT differs, engraved on each.
//
//   1. Print flat. The profile is extruded in Z, so there is not a single
//      overhang and the top bar never bridges. No supports.
//   2. Slide each band down over the Shortkiller from above.
//   3. The one that lands with the top bar just touching the case is SK_H.
//      Too tall rattles; too short will not go on.
//   4. Tell me that number.
//
// A band is only BAND_T thick along the box, so this is a cross-section test:
// it tells us the wrap CLOSES, not how the full-length frame behaves.
include <shortkiller_common.scad>
use <../lib/label.scad>

HEIGHTS = [45, 50, 55, 60];
BAND_T  = 10.0;   // thickness along the box axis — keep thin, it's a coupon
LEG_T   =  3.0;   // leg wall thickness
TOP_T   =  8.0;   // top bar — thick enough to engrave the number into
GAP     = 10.0;   // spacing on the plate

OUT_W = POCKET_W + 2 * LEG_T;

module band(h) {
    difference() {
        linear_extrude(BAND_T)
            difference() {
                square([OUT_W, h + TOP_T]);
                translate([LEG_T, -1]) square([POCKET_W, h + 1]);
            }
        // height engraved into the top bar
        translate([OUT_W / 2, h + TOP_T / 2, BAND_T])
            label_pocket(str(h), size = 5.0);
    }
}

// 2 x 2 on the plate — four bands side by side would run past the bed.
ROW_PITCH = HEIGHTS[len(HEIGHTS)-1] + TOP_T + GAP;
for (i = [0 : len(HEIGHTS)-1])
    translate([(i % 2) * (OUT_W + GAP), floor(i / 2) * ROW_PITCH, 0])
        band(HEIGHTS[i]);
