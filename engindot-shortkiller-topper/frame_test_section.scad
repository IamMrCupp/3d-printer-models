// frame_test_section — a 30 mm slice of engindot_frame.scad. PRINT THIS FIRST.
//
// Not a separate gauge: it calls the SAME frame() module at a short length, so
// the profile, the skirt, the ledge and the plate pocket are bit-identical to
// the real part. If this fits, the frame fits.
//
// Answers, for about 15 minutes and ~15 g:
//   1. Does the skirt drop over the lid snugly at the measured CASE_W = 84?
//   2. Does the plate seat in the pocket? Slide this onto the printed plate's
//      long edge — 0.6 mm clearance per side is the whole margin here, because
//      at an 84 mm case the skirt wall and the plate upstand are the same wall.
//   3. Does the 6 mm skirt sit where you want it against the side vents?
//
// PRINT: as rendered — walls DOWN, no supports. Same orientation as the frame.
include <shortkiller_common.scad>
use <engindot_frame.scad>

frame(30);
