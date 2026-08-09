// frame_length_gauge — checks the ONE dimension that has failed twice: the clear
// span between the frame's front and rear lips.
//
// A 10 mm strip carrying both end lips at their real positions, and nothing
// else. No skirts, no ledge, no plate pocket — those are the cross-section, and
// frame_test_section covers them.
//
//   1. Print flat as rendered. The profile is extruded in Z, so no overhangs,
//      no bridges, no supports. ~13 g.
//   2. Lay it along the TOP of the supply, front to back.
//   3. Both lips should drop over the front and rear top edges with a whisker
//      of slop. If it will not go on, the span is short; if it rattles fore and
//      aft, it is long. Tell me which and by how much.
//
// Span here is MOUNT_L - 2*END_BAR_T, derived from CASE_L. It is the same
// expression the real frame uses, so this cannot disagree with it.
include <shortkiller_common.scad>

GAUGE_W = 10.0;   // strip width — just enough to be rigid
SPINE_T =  5.0;   // spine thickness

SPAN = MOUNT_L - 2 * END_BAR_T;   // what has to clear the case: 197.65

linear_extrude(GAUGE_W)
    polygon([
        [-MOUNT_L/2,              -END_LIP_D],
        [-MOUNT_L/2 + END_BAR_T,  -END_LIP_D],
        [-MOUNT_L/2 + END_BAR_T,   0],
        [ MOUNT_L/2 - END_BAR_T,   0],
        [ MOUNT_L/2 - END_BAR_T,  -END_LIP_D],
        [ MOUNT_L/2,              -END_LIP_D],
        [ MOUNT_L/2,               SPINE_T],
        [-MOUNT_L/2,               SPINE_T],
    ]);

echo(str("clear span between lips = ", SPAN, " mm  (case ", CASE_L, ")"));
