// bin_shortkiller_griptest — FULL-LENGTH grip coupon. No Gridfinity base.
//
// The one thing bin_shortkiller_testfit could NOT tell you: how the flexures
// behave at their real span. That coupon is 2 cells, so its walls span ~63 mm
// against the real 147 mm, and beam stiffness goes as 1/length^3 — it grips
// several times too hard. This part has the true span.
//
// It also skips the entire Gridfinity base. In the real bin the pocket floor
// sits 21.9 mm up — feet, then the 45-degree flare ramp, then the floor — and
// none of that is doing anything for grip. Here it is a 3 mm slab instead.
// Everything above the floor is IDENTICAL geometry, from the same module.
//
// What it answers:
//   * do the bumps hold the box, or does it rock, at full span
//   * does the 9 mm backstop clear the rear DC jack and rocker
//   * does the box overhang look right at 171 mm in a 167.5 mm bin
//
// What it cannot answer: anything about seating in a plate — it has no foot.
// bin_shortkiller_testfit already covered that.
//
// PRINT: flat, slab down, no supports.
include <../../lib/gridfinity.scad>
include <../shortkiller_common.scad>
use <../bin_shortkiller.scad>

bin_shortkiller(NY_CRADLE, foot = false);
