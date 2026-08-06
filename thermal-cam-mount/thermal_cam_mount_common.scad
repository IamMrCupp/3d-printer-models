// thermal_cam_mount_common.scad — sandwich clamp holding a Sipeed T256s thermal
// camera on the LED-56S ring light's control-box tab, for the benchhud HUD.
//
// WHY: the T256s is registered onto the scope's visible feed so a hot component's
// bloom labels that component. The registration transform is computed once and
// must HOLD every session → rigid, non-drifting, fixed-angle mount.
//
// TAB (control box, measured 2026-07-23): 49.65 W (X) × 32.51 front-to-back (Y)
// × 26.42 thick (Z). The tab is a BOSS on top of the ring, so five of its faces
// are unusable: REAR merges into the ring, FRONT has the brightness wheel, the
// two SIDES have the switch and the jack, and the BOTTOM has a center screw.
// Only the TOP (scope-facing) face is fully clear.
//
// SANDWICH: a TOP plate and a BOTTOM plate grip the tab's top and bottom faces
// over the front ~28 mm; two screws at the FRONT CORNERS pass outboard of the
// tab (clear of the mid-side switch/jack, either side of the front wheel) and
// draw the plates together. No rear wall (misses the ring), no side walls (miss
// the controls). The bottom plate has a pocket for the center screw and carries
// the cam cradle. Long top+bottom grip = the moment arm that resists nose-down
// tilt from the cam's weight. TWO printed parts: mount_top + mount_bottom.
//
//   ⚠ First-print fit checks: FIT (plate-to-tab gap) and the front-corner screw
//     clearance. Confirm the top face is rigid ABS before trusting the grip.

$fn = 48;
EPS = 0.1;

// ---- tab (measured) ----
TAB_W  = 49.65;   // X width
TAB_FB = 32.51;   // Y front-to-back (front = +Y, away from ring)
TAB_T  = 26.42;   // Z thickness (top = +Z)
FIT    = 0.3;     // gap between each plate and the tab face

// ---- plates / fasteners ----
PLATE_T   = 5;    // each plate thickness
GRIP_LEN  = 28;   // how far back from the front the plates cover (of 32.51 → 4.5 rear clear)
BOSS_GAP  = 1.2;  // clearance from the tab side to the screw boss
BOSS_R    = 4.5;  // front-corner boss radius (M3 heat-set insert)
BOSS_INSET_Y = 6; // boss centre back from the front edge
INSERT_D  = 4.6;  // M3 heat-set insert bore (bottom-plate bosses)
SCREW_D   = 3.4;  // M3 clearance (top plate)
SCREW_CB  = 6.4;  // counterbore for the screw head
CENTER_POCKET_D = 13;   // clearance pocket over the tab's bottom center screw
CENTER_POCKET_H = 3.5;

// ---- Sipeed T256s (LOCKED) ----
CAM_W = 42; CAM_H = 35; CAM_D = 14;
CAM_CLR   = 0.6;
CAM_ANGLE = 30;   // tilt from vertical → lens looks down at the board

// ---- cradle ----
LIP=4.5; SIDE_H=16; CORNER=6; CABLE_W=12; WALL=3; ARM_DROP=7;
CABLE_DIR = "down";   // "down" (female/bottom port) | "side" (right-angle adapter)

// ============================================================================
// derived
half    = TAB_T/2 + FIT/2;                 // inner half-gap (plate face to centre)
y_front = TAB_FB/2;
y_back  = y_front - GRIP_LEN;
PW      = 2*(TAB_W/2 + BOSS_GAP + 2*BOSS_R);   // plate width (spans to the bosses)
boss_x  = TAB_W/2 + BOSS_GAP + BOSS_R;
boss_y  = y_front - BOSS_INSET_Y;
bot_z0  = -half - PLATE_T;                  // underside of the bottom plate

module _plate() {                            // flat footprint in X-Y, unit thickness at z=0
    translate([-PW/2, y_back, 0]) cube([PW, GRIP_LEN, PLATE_T]);
}

// Open cradle (upright frame, pre-tilt) — grips the cam bottom edge, both sides,
// top-front corners; lens (front) and most of the screen (back) stay open.
module _cradle() {
    iw = CAM_W + CAM_CLR; id = CAM_D + CAM_CLR;
    ow = iw + 2*WALL; oy = id + 2*WALL;
    difference() {
        union() {
            translate([-ow/2, 0, 0]) cube([ow, oy, LIP]);
            translate([-ow/2, 0, 0]) cube([WALL, oy, SIDE_H]);
            translate([ iw/2, 0, 0]) cube([WALL, oy, SIDE_H]);
            translate([-ow/2, oy - WALL, 0]) cube([ow, WALL, SIDE_H + WALL]);
            for (sx = [-ow/2, iw/2 - CORNER])
                translate([sx, 0, SIDE_H - EPS]) cube([WALL + CORNER, WALL + 2, WALL + EPS]);
        }
        translate([-iw/2, WALL, LIP]) cube([iw, id, CAM_H + CAM_CLR + 10]);
        if (CABLE_DIR == "down")
            translate([-CABLE_W/2, -EPS, -EPS]) cube([CABLE_W, oy + 2*EPS, LIP + 2*EPS]);
        else
            translate([-ow/2 - EPS, oy/2 - CABLE_W/2, -EPS]) cube([ow + 2*EPS, CABLE_W, LIP + 2*EPS]);
    }
}

// ---- part 1: bottom plate + bosses + cradle ----
module mount_bottom() {
    union() {
        difference() {
            union() {
                translate([0,0,bot_z0]) _plate();                         // plate
                for (sx = [-boss_x, boss_x])                              // front-corner bosses
                    translate([sx, boss_y, -half]) cylinder(r = BOSS_R, h = 2*half);
            }
            // heat-set inserts down into the bosses from the top
            for (sx = [-boss_x, boss_x])
                translate([sx, boss_y, half - 8]) cylinder(d = INSERT_D, h = 8 + EPS);
            // clearance pocket over the tab's bottom center screw
            translate([0, 0, -half - CENTER_POCKET_H])
                cylinder(d = CENTER_POCKET_D, h = CENTER_POCKET_H + EPS);
        }
        // arm from the plate underside down to the tilted cradle at the front
        aw = CAM_W + 2*WALL;
        translate([-aw/2, y_front - WALL, bot_z0 - ARM_DROP])
            cube([aw, WALL + 2, ARM_DROP + PLATE_T + EPS]);
        translate([0, y_front + EPS, bot_z0 - ARM_DROP])
            rotate([-(90 - CAM_ANGLE), 0, 0]) _cradle();
    }
}

// ---- part 2: top plate ----
module mount_top() {
    difference() {
        translate([0,0,half]) _plate();
        for (sx = [-boss_x, boss_x]) translate([sx, boss_y, half - EPS]) {
            cylinder(d = SCREW_D, h = PLATE_T + 2*EPS);
            translate([0,0,PLATE_T - 1.6]) cylinder(d = SCREW_CB, h = 1.6 + EPS);
        }
    }
}
