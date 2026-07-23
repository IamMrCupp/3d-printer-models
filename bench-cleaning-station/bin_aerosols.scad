// bin_aerosols — 5×2 three-can block: freeze spray + DeoxIT D5 + F5.
//
// 5×2, not 4×2. The three cans are 162 mm of bore, which looks like it fits 168,
// but bores also need webs between them and a wall outside them — at 4×2 two of
// them merge and the outer one breaks through the side. Still cheaper than three
// separate 2×2 cups (210 mm vs 252 mm).
include <cleaning_station_common.scad>
collar_cup_row(5, 2, [D_FREEZE_SPRAY, D_DEOXIT_D5, D_DEOXIT_F5], CAPTURE);
