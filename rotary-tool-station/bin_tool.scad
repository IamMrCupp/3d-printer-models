// bin_tool — 1×1 cup, the HARDELL standing vertical, cord slot to the side.
//
// BORED TO THE TAPER'S WIDEST POINT. The body runs 28 at the base to ≈30 at its
// widest, and a bore cut to the 28 would jam the tool partway down. TOOL_D is
// the 30 for exactly that reason.
//
// ⚠️ This REPLACES a cup bored to ⌀19.66 that carried this filename and this
// tool's name until 2026-08-25. That bore was the small engraver's — the file
// moved to `../engraver-station/bin_tool_engraver.scad` rather than being
// deleted, because the part was always correct, only mislabelled.
//
// CAPTURE IS A COMFORT CHOICE HERE, NOT A DERIVED NUMBER. The HARDELL's overall
// length has never been measured, and it does not need to be: the bin latches
// into the grid, so nothing tips, and with 1 mm of clearance in a 45 mm bore the
// tool leans about 1.3°. 45 holds plenty and leaves it easy to pinch out.
//
// PRINT: as emitted, feet down. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <rotary_station_common.scad>
use <../lib/vessel.scad>

assert(TOOL_D >= TOOL_D_BASE,
       "TOOL_D must be the WIDEST section — a bore cut to the narrow end jams.");

collar_cup(1, 1, TOOL_D, TOOL_CAPTURE, cord_w = CORD_W);
