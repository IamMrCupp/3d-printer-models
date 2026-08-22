// base_swabs — 3×2 stacking base for cotton buds / beauty swabs, with an open
// front so they roll out rather than being fished for.
//
// Its TOP is a Gridfinity baseplate, so bin_sponges socket-stacks straight onto
// it: swabs underneath, sponges above, one footprint on the grid instead of two.
//
// 3×2 rather than the 2×2 a swab bin would need on its own — the footprint has
// to match what stacks on top, and a 100.1 mm sponge does not fit a 2×2's 81 mm
// interior. See bin_sponges.
//
// PRINT: as emitted, feet down. No supports — the open front is swept into the
// pocket profile, so there is no overhang to bridge.
include <cleaning_station_common.scad>

SWAB_BASE_H = 45;   // [25:1:80] height of the swab compartment

stack_base(3, 2, SWAB_BASE_H, open_front = true);
