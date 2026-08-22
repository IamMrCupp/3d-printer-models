// base_swabs — 2×2 stacking base for cotton buds / beauty swabs, open at the
// front so they roll out rather than being fished for.
//
// Its TOP is a Gridfinity baseplate, so bin_sponges socket-stacks straight onto
// it: swabs underneath, sponges above, one 2×2 footprint instead of two bins.
//
// 2×2 is only possible because the sponges are cut to working size — at the full
// 100.1 mm block this tower had to be 3×2.
//
// PRINT: as emitted, feet down. No supports — the open front is swept into the
// pocket profile, so there is no overhang to bridge.
include <cleaning_station_common.scad>

SWAB_BASE_H = 45;   // [25:1:80] height of the swab compartment

stack_base(2, 2, SWAB_BASE_H, open_front = true);
