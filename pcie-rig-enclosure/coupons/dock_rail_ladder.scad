// dock_rail_ladder.scad — four dock rails at four peg sizes, on one sprue.
//
// The riser's mounting holes are 3.98. Small vertical pegs print off-nominal
// by an amount that's yours, not the model's, so print this, push the board
// onto each rail in turn, and set PEG_D in rig_common.scad to the one that
// holds without a fight. Snap the rails off the sprue; the two you keep are
// the two you glue in.

use <../rig_dock_rail.scad>
include <../rig_common.scad>

LADDER = [3.6, 3.7, 3.8, 3.9];
PITCH  = 14;

union() {
    for (i = [0 : 3])
        translate([(i - 1.5)*PITCH, 0, 0]) rig_dock_rail(peg_d = LADDER[i]);
    // sprue: joins the four bases into one body
    translate([-(1.5*PITCH + RAIL_W/2), -1, 0]) cube([3*PITCH + RAIL_W, 2, RAIL_T]);
}
