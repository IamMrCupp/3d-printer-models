// riser_pedestal_hotair.scad — 6" pedestal, ×4 under the hot air station.
//
// At 152.4 mm on an 84 mm square footprint this is 1.8:1 tall vs wide, past the
// MAX_ASPECT guideline — it renders with a warning rather than failing, because
// whether it can be widened depends on the station's foot spacing. If the feet
// are far enough apart to take 126 mm pedestals, render with -D GX=3 -D GY=3
// and the ratio drops to a comfortable 1.2:1.
//
// PRINT: as emitted, feet down. No supports. ×4.

include <riser_common.scad>

RISER_H = HOTAIR_RISE;

riser_pedestal(RISER_H);
