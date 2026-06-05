// apache_organizer_common.scad — shared bits for the Apache 5800 cord organizer.
//
// Case interior: 514 × 289 × 144 mm. The floor is a 12 × 6 Gridfinity grid
// (504 × 252) printed as two 6 × 6 tiles; the ~37 mm spare on one long side is
// a cable channel, ~5 mm border at each end. Tiles butt and the case walls hold
// them; 2 alignment pegs per mating edge keep them flush and slide-together.

include <../lib/gridfinity.scad>

TILE_NX = 6; TILE_NY = 6;       // each tile (252 × 252)
PEG_D = 3.5; PEG_L = 6; PEG_Y = 60;

// Tile with alignment pegs on +X edge and matching holes on -X edge, so two
// identical tiles chain along the case length.
module organizer_tile() {
    w = TILE_NX * GF;            // 252
    difference() {
        union() {
            baseplate(TILE_NX, TILE_NY);
            for (y = [PEG_Y, -PEG_Y]) translate([w/2, y, BP_H/2]) rotate([0,90,0]) cylinder(d = PEG_D, h = PEG_L); // +X pegs
        }
        for (y = [PEG_Y, -PEG_Y]) translate([-w/2 - 0.1, y, BP_H/2]) rotate([0,90,0]) cylinder(d = PEG_D + 0.4, h = PEG_L + 1); // -X holes
    }
}
