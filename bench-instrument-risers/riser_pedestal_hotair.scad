// riser_pedestal_hotair.scad — 4" pedestal, ×4 under the hot air station.
//
// At 101.6 mm on an 84 mm square footprint this is 1.21:1 tall vs wide, inside
// the MAX_ASPECT guideline (1.60) — so it renders clean. The 8" version this
// replaced measured 2.42:1 and tripped the warning on every render.
//
// Keep it at 2x2 regardless of height. Four 3x3 pedestals are 36 cells — an
// entire 6x6 plate edge to edge — which removes the whole reason to raise the
// station, since nothing is left underneath to put a bin in.
//
// PRINT: as emitted, feet down. No supports. ×4.

include <riser_common.scad>

RISER_H = HOTAIR_RISE;

riser_pedestal(RISER_H);
