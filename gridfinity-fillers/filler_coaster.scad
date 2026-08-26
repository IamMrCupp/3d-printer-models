// filler_coaster — filler tile with a dished top for a drink.
//
// A flat tile under a sweating glass just spreads the ring; this holds it. The
// rim is RECESS_WALL wide all round and the dish RECESS_D deep.
//
// PRINTS TOP-UP, not flipped — the dish would need supports upside down, and a
// coaster's surface finish doesn't matter the way a mouse surface does. The
// dish floor is a bridge over the tile's hollow; it spans one cell at most
// because the ribs run under it.
//
//     openscad -o c_2x2.stl --export-format binstl -D NX=2 -D NY=2 filler_coaster.scad

include <filler_common.scad>

difference() {
    filler_tile(NX, NY, plate_top = PLATE_TOP, top_t = RECESS_TOP_T);
    filler_recess(NX, NY);
}
