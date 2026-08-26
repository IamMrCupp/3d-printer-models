// bin_brushes — 2×1 bin, split down the middle, for cleaning brushes and
// toothbrushes. Two lanes so the dirty ones stay away from the clean ones.
//
// Brushes stand upright: a toothbrush is ~180 mm and would not lie in an 83 mm
// bin. BRUSH_H captures roughly a third of one, same rule as the rotary tool cup.
//
// PRINT: as emitted, feet down. No supports.
include <cleaning_station_common.scad>

BRUSH_H = 60;   // [30:1:120] bin height

divided_bin(2, 1, BRUSH_H, cols = 2, rows = 1);
