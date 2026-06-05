// vj_rig_stand_common.scad — shared library for the VJ rig stand.
//
// Holds an iPad (TouchOSC) in an angled cradle behind the keyboard, an Apple
// Magic Trackpad in a tray that partly frames the keyboard's right side, and a
// 3x Lightning cable holder. Two parts (combined unit is wider than the bed):
//
//   vj_cradle()  — iPad cradle + cable bar (left/center section)
//   vj_tray()    — trackpad tray + connecting arm (right section)
//
// They bolt together at a flange (2 screws; glue-compatible). Variants
// `vj_rig_stand_cradle.scad` / `_tray.scad` `include` this file.

/* [iPad cradle] */
cw        = 260;   // cradle width (iPad 8 cased ≈ 257); keeps the part under the 270 bed
ipad_ang  = 65;    // lean from horizontal
chan_w    = 16;    // bottom channel for the cased iPad (flip cover folds behind)
panel_t   = 8;     // rest-panel thickness
panel_len = 130;   // rest-panel length up the slope
lip_h     = 20;    // front lip catching the iPad bottom edge
gusset_d  = 52;    // wedge depth (front to vertical back)
foot_d    = 95;    // base foot depth

/* [Trackpad tray] */
tp_w   = 160; tp_d = 115;   // Magic Trackpad
tp_wall = 5; tp_lip = 11;   // tray walls / lip
arm_w  = 44;                // connecting arm width
tray_fwd = 58;              // how far the tray is slid forward of the cradle front

/* [Cables] */
cable_n = 3; cable_d = 9; cable_pitch = 40;

/* [Build] */
base_t = 6;
join_overlap = 24;          // cradle ledge width the tray bolts onto
screw_d = 3.6; screw_head = 7; pilot_d = 2.8;
$fn = 40;

// joint screws: in the cradle's right edge; the tray's arm laps on top and bolts down
join_screws = [[cw - 13, 24], [cw - 13, 74]];

module vj_cradle() {
    difference() {
        union() {
            cube([cw, foot_d, base_t]);                                   // base foot
            for (x = [0, cw - 12]) translate([x, 0, base_t]) rotate([90, 0, 90]) // side gussets
                linear_extrude(12) polygon([[0,0], [gusset_d,0], [gusset_d, gusset_d*tan(ipad_ang)]]);
            translate([0, chan_w, base_t]) rotate([-(90 - ipad_ang), 0, 0])      // iPad rest panel
                cube([cw, panel_t, panel_len]);
            cube([cw, 4, base_t + lip_h]);                                // front lip / channel front
            difference() {                                                // cable bar
                translate([cw/2 - (cable_n*cable_pitch)/2 - 10, foot_d - 20, base_t]) cube([cable_n*cable_pitch + 20, 18, 22]);
                for (i = [0 : cable_n-1]) translate([cw/2 + (i - (cable_n-1)/2)*cable_pitch, foot_d - 26, base_t + 14]) rotate([90,0,0]) cylinder(d = cable_d, h = 30);
            }
        }
        for (p = join_screws) translate([p[0], p[1], -1]) cylinder(h = base_t + 2, d = pilot_d); // pilots (screw from above)
    }
}

module vj_tray() {
    difference() {
        union() {
            // arm laps over the cradle's right edge (z = base_t) and reaches the tray
            translate([cw - join_overlap, 0, base_t]) cube([join_overlap + arm_w, foot_d, base_t]);
            translate([cw + 8, -tray_fwd, 0]) difference() {                          // trackpad tray (on desk)
                cube([tp_w + 2*tp_wall, tp_d + tp_wall, base_t + tp_lip]);
                translate([tp_wall, tp_wall, base_t]) cube([tp_w, tp_d, tp_lip + 1]);
                translate([(tp_w + 2*tp_wall)/2 - 25, -1, base_t]) cube([50, tp_wall + 2, tp_lip + 1]); // finger relief
            }
        }
        for (p = join_screws) translate([p[0], p[1], base_t - 1]) {                    // countersunk screws down into cradle
            cylinder(h = base_t + 2, d = screw_d);
            translate([0, 0, 1]) cylinder(h = 4, d1 = screw_d, d2 = screw_head);
        }
    }
}
