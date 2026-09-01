// bin_tool — 1×1 cup, the HARDELL standing vertical. No cord channel.
//
// THE BORE IS STATED, NOT DERIVED. TOOL_BORE is the FINISHED hole, so this
// passes clr = 0 — collar_cup would otherwise add the library's CLR = 1.0 on
// top. That is exactly what went wrong before: TOOL_D 30 + CLR 1.0 cut a 31.0
// bore while every comment claimed 30, and the printed cup was too tight.
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

assert(TOOL_BORE >= TOOL_D && TOOL_D >= TOOL_D_BASE,
       "bore must clear the taper's WIDEST section — one cut to the narrow end jams.");

collar_cup(1, 1, TOOL_BORE, TOOL_CAPTURE, clr = 0, cord_w = CORD_W);
