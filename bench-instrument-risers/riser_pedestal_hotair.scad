// riser_pedestal_hotair.scad — 8" pedestal, ×4 under the hot air station.
//
// At 203.2 mm on an 84 mm square footprint this is 2.42:1 tall vs wide, well
// past the MAX_ASPECT guideline — it renders with a warning rather than failing,
// because a pedestal is only tippy while you are placing the station on it. Once
// the station is down its chassis ties all four together.
//
// Widening does NOT rescue the ratio: -D GX=3 -D GY=3 still measures 1.61:1,
// which is over the same guideline. It also costs the whole reason to raise the
// station — four 3x3 pedestals are 36 cells, an entire 6x6 plate edge to edge,
// leaving no open grid underneath. Stay at 2x2 and place them carefully.
//
// PRINT: as emitted, feet down. No supports. ×4.

include <riser_common.scad>

RISER_H = HOTAIR_RISE;

riser_pedestal(RISER_H);
