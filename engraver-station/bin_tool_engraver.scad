// bin_tool_engraver — 1×1 cup, the small engraver standing vertical, cord slot
// to the side.
//
// ⚠️ THIS FILE MOVED, AND THAT MOVE IS THE WHOLE STORY. It lived in
// `rotary-tool-station/` as `bin_tool.scad`, labelled the HARDELL's cup, bored
// to ⌀19.66. On 2026-08-25 the HARDELL was measured at **28 mm at the base,
// tapering to ≈30** — so 19.66 was never the HARDELL. It is this tool, matching
// the ~20 mm the engraver reads across to within 0.34 mm.
//
// The cup was correct all along; only the label was wrong. Had it been printed
// under the old name it would simply not have taken the HARDELL, and no mesh
// check, assert, or CI job could have caught that — the part was watertight,
// manifold and exactly the size it claimed to be. Only a caliper on the right
// tool finds this class of error.
//
// TOOL_L is re-attributed on the same reasoning: it was recorded beside the
// 19.66 in one session, so it is almost certainly this tool's. Marked ⚠️ until
// somebody puts a tape on the engraver end to end.
//
// PRINT: as emitted, feet down. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <engraver_common.scad>
use <../lib/vessel.scad>

collar_cup(1, 1, TOOL_D, TOOL_CAPTURE, cord_w = CORD_W);
