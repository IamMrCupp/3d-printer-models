// selftest_fn — tessellation regression guard for the Gridfinity bin foot.
//
// NOT a model. Like lib/selftest.scad this exists only so CI has real geometry
// to validate; nothing here is meant to be printed.
//
// The bug it guards against: _bin_foot() built each chamfer with a hull whose
// end slab overshot the plane where the next solid started — the bottom hull's
// top slab ran 0.80–0.81 into a vertical section that also starts at 0.80, and
// the top hull's top slab ran 4.75–4.76 into a body block that starts at 4.75.
// Each overshoot duplicated the neighbouring solid's outer wall for 0.01 mm, so
// CGAL had to split that wall at the overshoot plane. A split vertex is
// computed, not copied, so it landed ~1e-4 mm off the arc vertex it was meant
// to coincide with, and the pair left sliver triangles behind. Once
// tools/validate_stl.py rounds coordinates to 4 decimals a sliver collapses into
// a duplicate edge and reads as non-manifold.
//
// The slivers were in every bin ever rendered. What varied was whether a given
// ($fn, nx) put one under the 4-decimal threshold — which is why the failures
// weren't monotonic in $fn and why raising $fn never helped. bin(nx, ny, 35) on
// the old library, X = 2 non-manifold edges, over ny ∈ 1..5:
//
//     $fn    1-wide  2-wide  3-wide  4-wide  5-wide
//       8      .       .       .       .       .
//      12      .       .       .       .       .
//      16      .       .       .       .       .
//      20      X       X       X       X       X
//      24      .       .       .       .       .
//      28      .       .       .       .       .
//      32      .       .       .       .       .
//      36      .       .       .       .       .
//      40      X       .       X       .       .
//      44      X       X       X       X       X
//      48      X       .       X       .       .
//      52      X       X       X       X       X
//      56      X       .       .       .       X
//      60      X       .       .       X       X
//      64      .       X       .       .       .
//      72      *       X       X       .       .
//      80      .       X       .       .       X
//      96      .       X       .       .       .
//     128      X       .       .       .       .
//
// (* = 1x1 passed, 1x2..1x5 failed — the only cell where ny mattered at all.
// Everywhere else the result was a function of $fn and nx only.)
//
// stack_base() tripped on 18 further ($fn, nx) pairs including $fn = 28 and 36,
// so no $fn was clean across the whole bin family — a "safe $fn" list would
// have been a lie, and an assert on $fn would have had nothing safe to allow.
//
// The fix is in _bin_foot(). bin, bin_blank, divided_bin and stack_base now all
// render clean at every one of the 475 ($fn, nx, ny) combos swept above, with
// no edge under 1e-3 mm anywhere. The durable guard is the sliver check in
// tools/validate_stl.py — it catches the near-degenerate triangle itself rather
// than waiting for one to round into a duplicate edge, so a future model can't
// pick an unlucky $fn and have CI wave it through. This file just keeps the
// specific combinations that used to fail in front of that check.
//
// Each case below is a combination that failed before the fix. Keep them.

include <gridfinity.scad>

PITCH = 220;

// $fn values that broke bin(), each at a width that failed there.
FN_BIN = [[20, 1], [40, 1], [44, 1], [48, 3], [52, 1], [56, 1],
          [60, 1], [64, 2], [72, 2], [80, 2], [96, 2], [128, 1]];

// The two $fn values only stack_base() caught — the ones that make a
// "safe $fn" list impossible.
FN_STACK = [[28, 5], [36, 2]];

for (i = [0 : len(FN_BIN) - 1])
    translate([i * PITCH, 0, 0]) bin(FN_BIN[i][1], 1, 12, $fn = FN_BIN[i][0]);

for (i = [0 : len(FN_STACK) - 1])
    translate([i * PITCH, PITCH, 0]) stack_base(FN_STACK[i][1], 1, 20, $fn = FN_STACK[i][0]);
