// bin_sponges — 3×2 bin for melamine sponges standing on edge (~4 across).
// 3×2 is the minimum: a 100 mm sponge does not fit a 2×2's 81 mm interior.
// Sponges get trimmed down in use, so offcuts share the bin with full ones.
include <cleaning_station_common.scad>
bin(3, 2, SPONGE_BIN_H);
