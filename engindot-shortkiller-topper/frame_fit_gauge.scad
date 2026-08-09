// frame_fit_gauge — PRINT THIS BEFORE ANOTHER FRAME. Five short collars, each
// a slice of engindot_frame.scad's cross-section at a different CASE_W.
//
// This is the coupon that should have existed before the first frame. CASE_W
// was never measured — it was read off a tape photo at 102 and printed straight
// into a real part, which then slipped over the supply.
//
//   1. Print flat. The profile is extruded in Z, so there are no overhangs at
//      all and no supports. ~30 minutes for all five.
//   2. Drop each collar over the top of the ENGINDOT like a ring.
//   3. The one that lands snug — slides on without force, no side-to-side slop
//      — is the real lid width. It is engraved on the top face.
//   4. Tell me that number and the frame is re-cut around it.
//
// 102 is included as a reference: it is the size that failed, so it should feel
// obviously loose. If every collar is loose the lid is wider than 102 and the
// problem is something else — say so rather than guessing.
//
// Each collar carries the REAL jaw profile — ledge, plate upstand, solid border,
// skirt — so it also shows whether the border sits where you want it against the
// case, not just whether the width is right.
include <shortkiller_common.scad>
use <../lib/label.scad>

WIDTHS  = [86, 90, 94, 98, 102];
GAUGE_T = 20.0;   // collar length along the case
GAP     = 10.0;

_TOP = LEDGE_T + PLATE_T_;

// Same profile as engindot_frame.scad, parameterised by case width.
function _prof(cw) =
    let (s_in = cw / 2 + CASE_CLR / 2, s_out = cw / 2 + CASE_CLR / 2 + SKIRT_T)
    [
        [POCKET_HW - LEDGE_IN,  0],
        [POCKET_HW - LEDGE_IN,  LEDGE_T],
        [POCKET_HW,             LEDGE_T],
        [POCKET_HW,             _TOP],
        [s_out,                 _TOP],
        [s_out,                -SKIRT_D],
        [s_in,                 -SKIRT_D],
        [s_in,                  0],
    ];

module collar(cw) {
    difference() {
        linear_extrude(GAUGE_T) {
            polygon(_prof(cw));
            mirror([1, 0]) polygon(_prof(cw));
            // bridge across the plate opening — holds the two jaws at spacing,
            // standing in for the bonded plate
            translate([-POCKET_HW, LEDGE_T])
                square([2 * POCKET_HW, _TOP - LEDGE_T]);
        }
        translate([0, (LEDGE_T + _TOP) / 2, GAUGE_T])
            label_pocket(str(cw), size = 6.0);
    }
}

ROW = SKIRT_D + _TOP + GAP;
for (i = [0 : len(WIDTHS) - 1])
    translate([(i % 2) * (WIDTHS[len(WIDTHS)-1] + 2 * SKIRT_T + GAP),
               floor(i / 2) * ROW,
               0])
        collar(WIDTHS[i]);
