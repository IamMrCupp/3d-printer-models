// spool_upper — upper flange and the journal.
//
// PRINT FLANGE-DOWN, as emitted: 2463 mm2 on the bed, and the journal steps
// inward going up, so it needs NO SUPPORT ANYWHERE. This is why the split is at
// the upper flange's underside rather than mid-hub — split at the hub and this
// piece becomes hub-then-flange, which overhangs whichever way up you print it.
include <spool_common.scad>
$fn = 96;
difference() {
    _upper_profile();
    // The socket must pass THROUGH the bottom face, never stop on it.
    translate([0, 0, -EPS]) _joint_socket();
}
