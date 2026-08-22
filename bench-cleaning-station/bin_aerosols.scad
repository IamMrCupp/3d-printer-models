// bin_aerosols — 5×2 block for the three DeoxIT cans. D5, F5 and G5 are the same
// can, so all three bores are the same: any can, any slot.
//
// The bore is BORE_DEOXIT, lifted straight from the bore that fits on the printed
// part. The freeze spray is a larger can and lives in bin_freeze_spray.
//
// PRINT: as emitted, feet down. No supports.
include <cleaning_station_common.scad>
collar_cup_row(5, 2, [BORE_DEOXIT, BORE_DEOXIT, BORE_DEOXIT], CAPTURE, clr = 0);
