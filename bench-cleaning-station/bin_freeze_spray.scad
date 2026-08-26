// bin_freeze_spray — 2×2 cup for the freeze spray can.
//
// Its own part because the can is 69 mm — 13 mm wider than a DeoxIT. Sharing a
// block with them forced one bore to cover both, and neither fitted.
//
// 2 mm clearance rather than lib/vessel.scad's 1.0: that figure is per-diameter
// and sized around a ~19 mm syringe, so on a 69 mm can it is proportionally far
// tighter. The DeoxIT bears this out — its can sits well in 57.00 and "barely"
// in 55.20, i.e. ~2 mm is the fit that works and ~0.5 mm is not.
//
// PRINT: as emitted, feet down. No supports.
include <cleaning_station_common.scad>
collar_cup(2, 2, D_FREEZE_SPRAY, CAPTURE, clr = FREEZE_CLR);
