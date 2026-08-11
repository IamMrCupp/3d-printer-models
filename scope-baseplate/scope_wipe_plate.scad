// scope_wipe_plate — 3×3 click-on plate for the microscope boom's weighted-base
// platform (print grid-up, no supports).
//
// NOT the oscilloscope — that one is `bench-instrument-risers/`.
//
// $fn must be >= 60. The border ring's inner boundary and the baseplate's outer
// boundary are rounded rects 1 mm apart with the same corner radius, so their
// corner arcs run nearly parallel; below 60 segments the facet vertices land
// close enough to stitch into sub-micron sliver triangles and the mesh validator
// rejects the part. Swept 48-128: fails at 48 and 56, clean at every value from
// 60 up. 96 leaves margin.
include <scope_plate_common.scad>
$fn = 96;
scope_wipe_plate();
