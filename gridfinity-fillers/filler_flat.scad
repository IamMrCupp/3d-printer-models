// filler_flat — plain flat-topped filler tile. The default.
//
// PRINT UPSIDE DOWN (top face on the bed). The file already flips it: every
// foot surface then tapers inward going up, so the part is self-supporting with
// no overhangs, and the working surface comes off the build plate glass-flat
// instead of as top solid infill. That matters for a mouse.
//
//     openscad -o f_3x2.stl --export-format binstl -D NX=3 -D NY=2 filler_flat.scad

include <filler_common.scad>

rotate([180, 0, 0]) filler_tile(NX, NY, plate_top = PLATE_TOP);
