// rotary_station_common.scad — HARDELL mini rotary tool + its accessories.
//
// The tool stands VERTICAL in a 1×1 cup rather than lying in a 4×1 trough. A cup
// captures the bottom ~45 mm and lets the remaining ~86 mm stick up, the way a
// pen sits in a pen cup — 4× less bench for the same tool.
//
// It's corded (barrel jack), so the cup carries a side channel open to the rim.
// Without one the lead drapes over the edge and levers the tool sideways.
// Store it COLLET-DOWN: a pointed burr at hand height on a bench you reach
// across is a snag you only notice once.

include <../lib/vessel.scad>
include <../lib/syringe.scad>

// ---- measured ----
TOOL_D   = 19.66;    // body diameter
TOOL_L   = 131.36;   // overall length (for reference; the cup captures a third)
BIT_SHANK = 2.381;   // 3/32" collet — 0.09375 × 25.4

TOOL_CAPTURE = 45;   // ≈ a third of TOOL_L
CORD_W       = 6;    // side channel for the barrel-jack lead

// ---- bit-hole clearance ----
// lib/vessel.scad's CLR = 1.0 mm is tuned for 50–80 mm vessels, where it's ~2%
// of the diameter. On a 2.381 mm shank the SAME 1.0 mm is 42% — the bits would
// rattle. Absolute clearance does not scale down; small bores need their own
// number.
//
// 0.25 mm is a starting point, not an answer. Small vertical holes come out of
// an FDM printer UNDERSIZE (inner-perimeter over-extrusion), typically by
// 0.15–0.3 mm, and how much is specific to your printer, nozzle, and filament.
// Print `bit_fit_gauge.scad` first, find the hole your shanks actually slide
// into, and set this to match. Guessing here means a block of 70 holes that are
// all slightly wrong.
BIT_CLR = 0.25;

// 70 holes covers the 69-piece accessory set as an upper bound. Not all 69 are
// shank-mounted — cut-off discs and drums come on mandrels, and the micro drill
// bits in the small case have their own shank sizes. Drop `BIT_COLS`/`BIT_ROWS`
// once you've counted what actually has a 3/32" shank.
BIT_COLS = 14; BIT_ROWS = 5;
BIT_CAPTURE = 18;   // bits are light; 18 mm keeps the block low under the hood
