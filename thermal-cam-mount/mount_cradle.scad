// mount_cradle — the cam cradle, its own part since v1.1.0.
//
// Tilt is chosen at ASSEMBLY, by where the second M3 sits in the arc slot in
// mount_top's arm: 30..55 deg from vertical. Not below 30 — the top plate's
// front corner clips the bottom of the camera's FOV there.
//
// PRINT UPRIGHT AS EXPORTED, NO SUPPORTS. 2.7% unsupported overhang standing on
// the lip, against 7.4% on its side and 16.9% on its back. That flipped when
// PAD_R came down from 16 to 12 — the big disc was the overhang.
include <thermal_cam_mount_common.scad>
mount_cradle();
