// bin_swabs — 2×2 bin for cotton buds and beauty swabs.
//
// Swabs stand on end. 2×2 rather than a bored block: they are consumables you
// grab a handful of, not items with a home each.
//
// PRINT: as emitted, feet down. No supports.
include <cleaning_station_common.scad>

SWAB_H = 60;   // [30:1:120] bin height

bin(2, 2, SWAB_H);
