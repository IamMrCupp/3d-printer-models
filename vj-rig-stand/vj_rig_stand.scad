// vj_rig_stand.scad — single-piece VJ rig stand.
//
// Holds an iPad (TouchOSC) in an angled cradle behind the keyboard, an Apple
// Magic Trackpad in a tray that partly frames the keyboard's right side, and a
// 3x Lightning cable holder. One flat-based piece — it's wider than the 270 mm
// bed, so split it in your slicer where convenient and add joiners.

/* [iPad cradle] */
cw        = 260;   // cradle width (iPad 8 cased ≈ 257)
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
tray_gap = 10;              // gap from cradle right edge to tray
tray_fwd = 58;              // how far the tray is slid forward of the cradle front

/* [Cables] */
cable_n = 3; cable_d = 9; cable_pitch = 40;

base_t = 6;
$fn = 40;

module tray_box() {
    difference() {
        cube([tp_w + 2*tp_wall, tp_d + tp_wall, base_t + tp_lip]);
        translate([tp_wall, tp_wall, base_t]) cube([tp_w, tp_d, tp_lip + 1]);
        translate([(tp_w + 2*tp_wall)/2 - 25, -1, base_t]) cube([50, tp_wall + 2, tp_lip + 1]); // finger relief
    }
}

module vj_stand() {
    union() {
        // ---- iPad cradle ----
        cube([cw, foot_d, base_t]);                                       // base foot
        for (x = [0, cw - 12]) translate([x, 0, base_t]) rotate([90, 0, 90])  // side gussets
            linear_extrude(12) polygon([[0,0], [gusset_d,0], [gusset_d, gusset_d*tan(ipad_ang)]]);
        translate([0, chan_w, base_t]) rotate([-(90 - ipad_ang), 0, 0])       // iPad rest panel
            cube([cw, panel_t, panel_len]);
        cube([cw, 4, base_t + lip_h]);                                    // front lip / channel front
        difference() {                                                    // cable bar
            translate([cw/2 - (cable_n*cable_pitch)/2 - 10, foot_d - 20, base_t]) cube([cable_n*cable_pitch + 20, 18, 22]);
            for (i = [0 : cable_n-1]) translate([cw/2 + (i - (cable_n-1)/2)*cable_pitch, foot_d - 26, base_t + 14]) rotate([90,0,0]) cylinder(d = cable_d, h = 30);
        }
        // ---- flat connecting base (no lap, no step) ----
        translate([cw - 2, 0, 0]) cube([tray_gap + tp_wall + 4, foot_d, base_t]);
        // ---- trackpad tray (slid forward, partly framing the keyboard) ----
        translate([cw + tray_gap, -tray_fwd, 0]) tray_box();
    }
}

vj_stand();
