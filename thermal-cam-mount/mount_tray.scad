// mount_tray — the camera tray and its yoke, pivoting on the arm legs.
//
// SET THE ANGLE ON THE BENCH, NOT IN THIS FILE. The yoke pivots on one M3 and
// locks with a second dropped through one of the leg's index holes — 15 to 45
// deg in 5 deg steps. The tilt was fixed at 14 for months, inherited from a
// downloaded model, and the thermal view landed 2-3 cm off the scope's field.
//
// PRINT: as emitted, tray floor DOWN. The yoke arms rise off it and carry
// themselves; the pocket, pads and lips are all open upward.
include <thermal_cam_mount_common.scad>
$fn = 64;
_tray_yoked();
