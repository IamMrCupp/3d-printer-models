// bin_dslogic — dock for a DSLogic Plus (74 x 79 x 9).
//
// OPEN FRONT, and it is doing two jobs. The probe connectors are on the pod's
// front face, so a full front wall would turn a dock into a storage box — you
// would lift it out to plug the harness in every time. It also solves removal:
// at 9 mm the pod is a slab, and a slab at the bottom of a closed well has
// nothing to pinch. It slides out forward instead.
//
// Rear notch takes the USB lead that runs to the computer.
//
// PRINT: as emitted, foot down. No supports. x1.
include <instrument_holders_common.scad>

difference() {
    open_front_bin(2, 3, H_DSLOGIC);
    rear_cord_notch(2, 3, H_DSLOGIC, x_off = DSLOGIC_NOTCH_X);
}
