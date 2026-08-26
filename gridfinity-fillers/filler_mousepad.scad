// filler_mousepad — filler tile with a shallow inset for a cut-down mouse pad.
//
// Bare PETG works under an optical mouse but isn't good. This sinks a pad flush
// with the rim so the pad edge can't be caught and peeled.
//
// Cut the pad to (NX*42 - 0.5 - 2*RECESS_WALL) x (NY*42 - 0.5 - 2*RECESS_WALL).
// RECESS_D defaults to 2.00; set it to your pad's actual thickness so the pad
// finishes flush — measure the pad, don't assume.
//
// PRINTS TOP-UP for the same reason as the coaster.
//
//     openscad -o m_4x3.stl --export-format binstl -D NX=4 -D NY=3 -D RECESS_D=3 filler_mousepad.scad

include <filler_common.scad>

difference() {
    filler_tile(NX, NY, plate_top = PLATE_TOP, top_t = RECESS_TOP_T);
    filler_recess(NX, NY, depth = RECESS_D, wall = RECESS_WALL);
}
