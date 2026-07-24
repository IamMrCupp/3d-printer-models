// thermal_cam_mount_common.scad — clamp a Sipeed T256s thermal camera onto the
// LED-56S ring light's control-box tab, for the benchhud thermal-fusion HUD.
//
// WHY: the T256s is registered onto the scope's visible feed so a hot component's
// bloom labels that component. The registration transform is computed once and
// must HOLD every session — so the mount is rigid, non-drifting, fixed-angle.
// Wobble = re-calibrate every sit-down. This is the physical half of registration.
//
// TAB (LED-56S control box) — all three axes measured 2026-07-23:
//   X width (tangential) .... 49.65   sides carry the SWITCH and the JACK
//   Y front-to-back ......... 32.51   FRONT face carries the brightness WHEEL;
//                                     REAR meets the ring (the root)
//   Z thickness (top↔bottom)  26.42   the axis the clamp pinches
//
// CLAMP APPROACH: three faces are occupied (both sides + front), so the clamp
// can't wrap the tab. It's a C-channel gripping TOP + BOTTOM + REAR only — open
// on both sides (clears switch + jack) and the front (clears the wheel). It
// slides on from the front until the rear wall seats against the root, then a
// single set-screw through the TOP pad preloads the joint. The screw and every
// wall stay off all three control faces.
//   ⚠ The set-screw presses the tab's TOP face — confirm that face is rigid ABS,
//     not the frosted diffuser. If it's diffuser, move the screw to a rigid rim
//     or add a bottom-pad screw instead.
//
// CAM hangs below the bottom face: screen toward +Y (the user), lens angled down
// at the board, USB-C exiting straight down (female/bottom port). CABLE_DIR flips
// the cradle's cable channel to a side if a right-angle adapter is added later.

$fn = 64;
EPS = 0.1;

// ---- tab (measured) ----
TAB_W  = 49.65;   // X width
TAB_FB = 32.51;   // Y front-to-back
TAB_T  = 26.42;   // Z thickness (pinch axis)
TAB_CLR = 0.5;    // bore clearance around the tab

// ---- C-clamp ----
PAD_T    = 5;     // top/bottom pad thickness
REAR_T   = 5;     // rear wall (braces the root)
GRIP_LEN = 22;    // how far forward the pads reach (leaves the front ~10 mm + wheel clear)
WALL     = 3;
SCREW_D  = 4.2;   // M4 set-screw clearance / self-tap pilot through the top pad
SCREW_HEAD = 8;   // counterbore so the head sits flush-ish on the top pad

// ---- Sipeed T256s (LOCKED) ----
CAM_W = 42; CAM_H = 35; CAM_D = 14;   // width × height × depth
CAM_CLR   = 0.6;
CAM_ANGLE = 30;   // tilt from vertical → lens looks roughly down at the board

// ---- cradle ----
LIP      = 4.5;   // bottom-edge catch the cam sits into
SIDE_H   = 16;    // side-wall rise up the 35 mm cam height
CORNER   = 6;     // top-front corner catches
CABLE_W  = 12;    // cable slot
CABLE_DIR = "down";   // "down" (female/bottom port) | "side" (right-angle adapter)
ARM_DROP = 7;     // cradle sits just below the tab

// ============================================================================
// FRAME: X = tab width, Y = front(+)/rear(-) , Z = top(+)/bottom(-). Tab centred.

// C-channel gripping top + bottom + rear. Open front and both sides.
module _tab_clip() {
    it = TAB_T + TAB_CLR;                 // inner gap (thickness)
    ow = TAB_W + TAB_CLR + 2*WALL;        // outer width (pads overhang the sides a touch)
    y_rear = -TAB_FB/2 - TAB_CLR/2;       // rear inner face
    difference() {
        union() {
            // top + bottom pads
            translate([-ow/2, y_rear, it/2])          cube([ow, GRIP_LEN, PAD_T]);
            translate([-ow/2, y_rear, -it/2 - PAD_T]) cube([ow, GRIP_LEN, PAD_T]);
            // rear wall joining them (overlaps both pads in z)
            translate([-ow/2, y_rear - REAR_T, -it/2 - PAD_T])
                cube([ow, REAR_T + EPS, it + 2*PAD_T]);
        }
        // set-screw through the top pad, ~⅔ forward, pressing the tab top
        translate([0, y_rear + GRIP_LEN*0.6, it/2 - EPS]) {
            cylinder(d = SCREW_D, h = PAD_T + 2*EPS);
            translate([0, 0, PAD_T - 1.5]) cylinder(d = SCREW_HEAD, h = 1.6 + EPS);
        }
    }
}

// Open cradle (upright frame, pre-tilt): back plate + bottom lip + two side walls
// + top-front corner catches. Grips bottom edge, both sides, top corners; the
// lens face (front) and most of the screen (back) stay open, alu body heatsinks.
module _cradle() {
    iw = CAM_W + CAM_CLR; id = CAM_D + CAM_CLR;
    ow = iw + 2*WALL; oy = id + 2*WALL;
    difference() {
        union() {
            translate([-ow/2, 0, 0]) cube([ow, oy, LIP]);                 // bottom tray
            translate([-ow/2, 0, 0]) cube([WALL, oy, SIDE_H]);            // left wall
            translate([ iw/2, 0, 0]) cube([WALL, oy, SIDE_H]);            // right wall
            translate([-ow/2, oy - WALL, 0]) cube([ow, WALL, SIDE_H+WALL]); // back plate
            for (sx = [-ow/2, iw/2 - CORNER])                             // top-front catches
                translate([sx, 0, SIDE_H - EPS]) cube([WALL + CORNER, WALL + 2, WALL + EPS]);
        }
        translate([-iw/2, WALL, LIP]) cube([iw, id, CAM_H + CAM_CLR + 10]); // cam cavity
        // cable slot: straight down, or out a side for a right-angle adapter
        if (CABLE_DIR == "down")
            translate([-CABLE_W/2, -EPS, -EPS]) cube([CABLE_W, oy + 2*EPS, LIP + 2*EPS]);
        else
            translate([-ow/2 - EPS, oy/2 - CABLE_W/2, -EPS]) cube([ow + 2*EPS, CABLE_W, LIP + 2*EPS]);
    }
}

module thermal_cam_mount() {
    it = TAB_T + TAB_CLR;
    ow = TAB_W + TAB_CLR + 2*WALL;
    y_rear = -TAB_FB/2 - TAB_CLR/2;
    bottom_z = -it/2 - PAD_T;             // underside of the bottom pad
    union() {
        _tab_clip();
        // arm: a block under the bottom pad, inset from the pad width so their
        // side faces don't coincide, dropping to the cradle at the front.
        aw = ow - WALL;
        arm_y = y_rear + GRIP_LEN - WALL;
        translate([-aw/2, arm_y, bottom_z - ARM_DROP])
            cube([aw, WALL + 2, ARM_DROP + PAD_T + EPS]);
        // cradle, tilted so the lens aims down-and-out toward the board
        translate([0, arm_y + WALL + EPS, bottom_z - ARM_DROP])
            rotate([-(90 - CAM_ANGLE), 0, 0]) _cradle();
    }
}
