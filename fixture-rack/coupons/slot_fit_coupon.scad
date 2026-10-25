// slot_fit_coupon — print first. A 20 mm slice through the fixture rack's three
// slots, at the rack's exact widths and divider thicknesses, flat-bottomed.
//
// Stand each fixture's edge in its slot. Back to front (the wide end of the
// coupon is the back): heat mat (thin), RL-605 (widest), TF5. Want: each drops in
// by hand with a little side play and no forcing. Too tight or too sloppy →
// change CLR in fixture_rack_common.scad and the rack follows.
//
// PRINT: flat as emitted, no supports. ~12 g.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../fixture_rack_common.scad>
coupon();
