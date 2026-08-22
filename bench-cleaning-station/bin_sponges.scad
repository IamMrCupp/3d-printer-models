// bin_sponges — 2×2 bin for melamine sponges cut to working size.
//
// 2×2, not 3×2. A full 100.1 mm block does not fit a 2×2's 81 mm interior, but
// nothing here stores full blocks: they get quartered (CUT_L 50.05 × CUT_W 29.85)
// because a whole block is more sponge than any bench job needs and melamine is
// consumed by abrasion. Bulk stock stays in the bag under the desk.
//
// The height still allows a FULL block on edge, so one uncut reserve can ride
// along with the trimmed pieces.
//
// Dropping to 2×2 is what lets base_swabs stack under it at 2×2 as well — a
// third less grid than the old 3×2 tower.
//
// PRINT: as emitted, feet down. No supports.
include <cleaning_station_common.scad>
bin(2, 2, SPONGE_BIN_H);
