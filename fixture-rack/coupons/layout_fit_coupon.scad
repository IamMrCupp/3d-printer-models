// layout_fit_coupon — print first. The fixture rack's exact top-view layout at
// full length, 5 mm tall, no floor, no feet: every wall and divider where the
// rack puts them, for ~25 g.
//
// Lay each fixture on its edge in its slot. Back to front: heat mat (narrowest
// slot), RL-605 (widest — open at both ends, its knobs hang out over them), TF5.
// Want: the mat and TF5 fit between the end walls; every piece drops in by hand
// with a little side play. Too tight or too loose → change CLR in
// fixture_rack_common.scad and the rack follows.
//
// PRINT: flat as emitted, no supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../fixture_rack_common.scad>
layout_coupon();
