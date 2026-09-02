// Fit coupon for the thermal camera tray: the tray alone, flat on the bed, no
// arm and no clamp plates. ~8 g against 14 g + 4 h for the real mount. Drop the
// camera in. It should slide in with light thumb pressure and stay put when the
// coupon is turned upside down.
include <../thermal_cam_mount_common.scad>
$fn = 64;
_tray();
