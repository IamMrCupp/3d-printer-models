// frame_width_gauge — the width equivalent of frame_length_gauge. One job.
//
// A 10 mm strip carrying the two skirt walls at their real spacing, and nothing
// else. Lay it across the TOP of the supply; both skirts should drop over the
// sides snug, no rock.
//
// Span is 2*SKIRT_IN, the same expression the real frame uses.
//
// NOTE: this checks the case fit ONLY. It does not check the plate pocket —
// frame_test_section does that, at the cost of being a full four-sided slice.
//
// PRINT: flat as rendered. Profile extruded in Z: no overhangs, no supports.
include <../shortkiller_common.scad>

GAUGE_D = 10.0;   // strip depth along the case
SPINE_T =  5.0;

SPAN = 2 * SKIRT_IN;   // what has to clear the case

linear_extrude(GAUGE_D)
    polygon([
        [-SKIRT_OUT, -SKIRT_D],
        [-SKIRT_IN,  -SKIRT_D],
        [-SKIRT_IN,   0],
        [ SKIRT_IN,   0],
        [ SKIRT_IN,  -SKIRT_D],
        [ SKIRT_OUT, -SKIRT_D],
        [ SKIRT_OUT,  SPINE_T],
        [-SKIRT_OUT,  SPINE_T],
    ]);

echo(str("clear span between skirts = ", SPAN, " mm  (case ", CASE_W, ")"));
