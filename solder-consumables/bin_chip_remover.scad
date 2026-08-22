// bin_chip_remover — 1×5 trough for the chip-removal alloy tube.
//
// A plain bin, not a shaped cradle: it is a rigid tube with walls around it, and
// a contoured channel would only matter if it needed to sit in one orientation.
//
// PRINT: as emitted, feet down. No supports.
include <../lib/gridfinity.scad>

TUBE_H = 30;   // [16:1:60] bin height. Raise if the tube stands proud of the rim.

bin(1, 5, TUBE_H);
