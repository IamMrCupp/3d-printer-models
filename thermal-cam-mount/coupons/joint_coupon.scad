// joint_coupon — the pivot joint alone: one leg end and one yoke paddle.
//
// Prints the ONLY untested mechanism in the adjustable mount for a few grams
// instead of 48: does an M3 pivot through the yoke seat in the leg's nut trap,
// and does a 1.75 mm filament stub drop through the yoke's index hole into each
// of the leg's four? Both parts lie flat. Slide them together, screw, pin.
//
// If the pin won't pass or the yoke binds on the leg face, STOP and say which —
// that is a clearance number, not a redesign.
include <../thermal_cam_mount_common.scad>
$fn = 48;

// Leg end: the bottom LEG_STUB mm of one leg, laid on its outer face.
LEG_STUB = 28;
translate([0, 0, 0])
    rotate([0, 90, 0])                        // outer face (x = LEG_XO) down onto z = 0
        translate([-LEG_XO, 0, 0])
            intersection() {
                _arm();
                translate([LEG_XI - 1, PIV_Y - IDX_R - 6, PIV_Z - LEG_END_R - 1])
                    cube([ARM_LEG + 2, IDX_R + 14, LEG_STUB]);
            }

// Yoke paddle: one, laid flat beside it.
translate([45, -PIV_LY, 0])
    linear_extrude(YOKE_T) _yoke_2d();
