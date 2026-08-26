// bin_tips — 1x1 bin for syringe tips.
//
// PRINT: as emitted, feet down. No supports.
include <../lib/gridfinity.scad>

TIP_H = 30;   // [16:1:60] bin height

bin(1, 1, TIP_H);
