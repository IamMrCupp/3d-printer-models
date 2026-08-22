// bin_deoxit_droppers — 2×1 block for the three DeoxIT concentrate droppers
// (D100 / F100 / G100), bare bottles out of their kit boxes.
//
// One 2×1 for all three. The kit boxes are a full 2×1 EACH, so decanting saves
// two units of grid — which is what lets these sit in front of the spray block
// instead of beside it.
//
// The tips and brushes that came in the boxes need their own home; a small
// divided bin covers that.
//
// PRINT: as emitted, feet down. No supports.
include <cleaning_station_common.scad>
collar_cup_row(2, 1, [D_DROPPER, D_DROPPER, D_DROPPER], CAP_DROPPER);
