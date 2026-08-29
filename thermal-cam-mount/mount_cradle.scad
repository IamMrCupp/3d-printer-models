// mount_cradle — the cam cradle, its own part since v1.1.0.
//
// Tilt is chosen at ASSEMBLY, by which index hole in mount_top's arm the second
// M3 goes through: 30..55 deg from vertical in 5 deg steps. Not below 30 — the
// top plate's front corner clips the bottom of the camera's FOV there.
//
// PRINTED ON ITS SIDE, PAD DOWN. That is both the cheapest orientation (7.5%
// unsupported overhang against 16.2% standing up) and the right one: the pad is
// the joint's mating face, and printing it against the bed makes it flat.
include <thermal_cam_mount_common.scad>
rotate([0, 90, 0]) mount_cradle();
