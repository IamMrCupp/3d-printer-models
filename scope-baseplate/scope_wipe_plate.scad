// scope_wipe_plate — 3×3 click-on plate for the microscope boom's weighted-base
// platform (print grid-up, no supports).
//
// NOT the oscilloscope — that one is `bench-instrument-risers/`.
//
// $fn is a plain smoothness choice — 48 matches the rest of the repo. It is NOT
// load-bearing: the border ring's inner boundary is the same expression the
// baseplate uses for its outline, so the two merge exactly at any tessellation.
// Verified clean at $fn 32/48/56/64/96.
include <scope_plate_common.scad>
$fn = 48;
scope_wipe_plate();
