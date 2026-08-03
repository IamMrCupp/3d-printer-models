// bin_shortkiller_testfit — PRINT THIS BEFORE THE REAL BIN.
//
// A 2-cell-deep slice of bin_shortkiller: same Gridfinity foot, same pocket
// width, same flexures and grip bumps, ~1/3 the filament and time. It answers
// the two things a photo can't:
//
//   1. Does the Shortkiller actually drop into a 98 mm pocket? (SK_W check)
//   2. Does a bin foot seat in your Clickfinity plates? (grid check)
//
// ⚠️ THE GRIP WILL FEEL TOO STIFF. The flexures here span ~63 mm against the
// real bin's ~147 mm, and a shorter beam is much stiffer — so read this coupon
// for FIT, not for feel. If the box drops in and the bumps touch, the full bin
// will grip more softly and that's correct.
//
// PRINT: flat, foot down, no supports.
include <../lib/gridfinity.scad>
include <shortkiller_common.scad>
use <bin_shortkiller.scad>

bin_shortkiller(2, lips = false);   // pure cross-section — no end lips
