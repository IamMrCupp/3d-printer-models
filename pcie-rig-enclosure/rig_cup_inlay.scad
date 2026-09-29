// rig_cup_inlay.scad — the second colour for rig_cup.scad.
//
// The letters that fill every label pocket on the cup, flush, in the same
// print orientation and at the same origin. In the slicer: load rig_cup.stl,
// add this as a part of the same object, give it the second filament.
//
// The deck label (GND) sits in the first layers, face-down on the bed. The
// wall labels print vertically, so each layer that crosses one costs a tool
// change — about 25 per wall at 5 mm text. Fine on the U1's toolchanger.

include <rig_cup.scad>
INLAY = true;
