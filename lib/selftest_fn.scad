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
// The slivers were in every bin ever rendered. What varied was whether one fell
// under the 4-decimal threshold — which is why the failures weren't monotonic in
// $fn and why raising $fn never helped.
//
// Sweeping bin_blank(nx, 1, h) over $fn × nx ∈ 1..5 × h ∈ {12, 21, 35, 42, 60},
// 475 combinations, on the old library:
//
//     287 carried a sliver
//     136 of those got caught — the rest passed CI with the defect intact
//     188 were clean
//
// So the old validator caught fewer than half the bad meshes, and h moves the
// result as readily as $fn and nx do. bin(nx, ny, 35), X = 2 non-manifold
// edges, over ny ∈ 1..5 — one slice through that space:
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
// (* = 1x1 passed, 1x2..1x5 failed — the only cell where ny mattered at this
// height. Read the map as one slice, not the whole story: at h = 42 rather than
// 35, $fn = 32 fails at every width.)
//
// A note for the next person who suspects _bin_cell(): rewriting its rounding as
// a hull of circles instead of offset(r) offset(-r) does NOT fix this. Measured
// on the same 475 combinations, it goes from 287 sliver-carrying to 250 — it
// moves which combinations are unlucky, nothing more. The overshoot fix alone
// takes it to 0. Both together are also 0, so the hull rewrite adds nothing
// here. (It is dimensionally more accurate for a separate reason — see the note
// on _bin_cell in gridfinity.scad — but that is a fit question, not this one.)
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

// [$fn, nx, h] — height is its own axis, so the guard has to cover it. The
// first entry is the reported repro: bin_blank(1,1,42) at $fn = 32, which the
// h = 35 map above calls clean. The rest are $fn values that failed at all 25
// (nx, h) combinations swept.
FN_H = [[32, 1, 42], [48, 2, 21], [72, 3, 60], [128, 4, 12], [32, 5, 35]];

for (i = [0 : len(FN_BIN) - 1])
    translate([i * PITCH, 0, 0]) bin(FN_BIN[i][1], 1, 12, $fn = FN_BIN[i][0]);

for (i = [0 : len(FN_STACK) - 1])
    translate([i * PITCH, PITCH, 0]) stack_base(FN_STACK[i][1], 1, 20, $fn = FN_STACK[i][0]);

for (i = [0 : len(FN_H) - 1])
    translate([i * PITCH, 2 * PITCH, 0])
        bin_blank(FN_H[i][1], 1, FN_H[i][2], $fn = FN_H[i][0]);
