// respool_drag_washer — drops over the post onto the source spool's top flange.
//
// THIS IS THE PART THAT MAKES THE WIND TIGHT. Without drag the source spool
// overruns every time you pause and the braid births a nest. Its own weight
// supplies the drag, which is why it is a solid disc and not a spring: a printed
// spring at this size relaxes, and this has to work the same on a 44.75 mm spool
// and a 13.50 mm one. Weight does; preload does not.
//
// Want more drag? Print it solid, or rest a coin on it.
//
// PRINT: flat, as emitted. No supports.
include <respool_common.scad>
$fn = 96;
difference() {
    cylinder(d = WASHER_D, h = WASHER_H);
    translate([0, 0, -EPS])
        cylinder(d = POST_D + 2*WASHER_CLR, h = WASHER_H + 2*EPS);
}
