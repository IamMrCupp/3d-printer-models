// stand_cable_clamp_common.scad — modular cable clamp for round stand poles.
//
// A split C-clamp pops over the pole and an M5 bolt + wingnut cinches it tight
// (the bolt head is captured in a hex pocket, so you only turn the wingnut —
// tool-free reposition). A dovetail on the clamp face takes slide-on cable
// heads, so one clamp accepts any attachment.
//
//   clamp(tube_d)   — the pole clamp (set tube_d to your pole OD)
//   head_hook()     — open J-hook
//   head_clip()     — snap cable clip
//   head_comb()     — multi-cable comb
//   head_velcro()   — velcro-strap slot
//
// On-Stage SS8800B+ measured diameters: upper shaft ≈ 34.9 mm (1⅜") / 38.1 mm
// (1½" w/ sleeve), tripod legs 35.38 mm, crank-up column 41.41 mm. Variant files
// clamp_leg.scad (35.38) and clamp_column.scad (41.41) cover the latter two.

TUBE_D = 35;        // pole outer diameter (set per stand)
CLEAR  = 0.6;       // clamp bore clearance
WALL   = 5;         // clamp wall
H      = 22;        // clamp height (along the pole)
GAP    = 4;         // split-gap width
EAR_L  = 18; EAR_W = 10;
BOLT_D = 5.4;       // M5 clearance
HEX_AF = 8.2;       // M5 hex head/nut across-flats (capture pocket)
HEX_T  = 4.5;

// dovetail (undercut: mouth narrower than back so the head can't pull out)
DT_MOUTH = 11; DT_BACK = 17; DT_DEPTH = 6; DT_H = 18; DT_STOP = 3; DT_CLEAR = 0.5;
CABLE_D = 8;        // nominal cable diameter for clip/comb

$fn = 64;

// dovetail solid: mouth (narrow) at x=0 facing -X, widening to back at x=depth, extruded up Z
module dt_prism(mouth, back, depth, h) {
    linear_extrude(h) polygon([[0, -mouth/2], [0, mouth/2], [depth, back/2], [depth, -back/2]]);
}
module dt_tongue() { dt_prism(DT_MOUTH - DT_CLEAR, DT_BACK - DT_CLEAR, DT_DEPTH - 0.3, DT_H); }

// ---- clamp ----
module clamp(tube_d = TUBE_D) {
    ir = tube_d / 2 + CLEAR; orr = ir + WALL;
    boss_x = -orr - DT_DEPTH - 2;        // -X outer face of the dovetail boss
    difference() {
        union() {
            cylinder(h = H, r = orr);
            translate([orr - 3, GAP / 2, 0]) cube([EAR_L, EAR_W, H]);            // +Y ear
            translate([orr - 3, -GAP / 2 - EAR_W, 0]) cube([EAR_L, EAR_W, H]);   // -Y ear
            translate([boss_x, -(DT_BACK / 2 + 4), 0]) cube([DT_DEPTH + 5, DT_BACK + 8, H]); // dovetail boss
        }
        translate([0, 0, 0]) cylinder(h = 3 * H, r = ir, center = true);         // bore
        translate([0, -GAP / 2, -1]) cube([orr + EAR_L + 5, GAP, H + 2]);        // split slot
        // wingnut bolt through the ears (along Y)
        translate([orr + EAR_L - 8, GAP / 2 + EAR_W + 3, H / 2]) rotate([90, 0, 0]) cylinder(h = 2 * EAR_W + GAP + 8, d = BOLT_D);
        // hex pocket captures the bolt head on the +Y ear outer face
        translate([orr + EAR_L - 8, GAP / 2 + EAR_W + HEX_T, H / 2]) rotate([90, 0, 0]) cylinder(h = HEX_T + 1, d = HEX_AF / cos(30), $fn = 6);
        // dovetail socket groove (open top, solid below DT_STOP as a slide stop)
        translate([boss_x, 0, DT_STOP]) dt_prism(DT_MOUTH, DT_BACK, DT_DEPTH, H);
    }
}

// ---- heads (universal; mount via the dovetail tongue at x=0..DT_DEPTH) ----
module _backplate(t = 4) { translate([-t, -DT_BACK / 2, 0]) cube([t, DT_BACK, DT_H]); }

module head_hook() {
    dt_tongue(); _backplate();
    translate([-4, 0, DT_H / 2]) rotate([90, 0, 0])
        rotate_extrude(angle = 250) translate([16, 0]) circle(d = 7);
}
module head_clip(clip_w = 12) {
    dt_tongue(); _backplate();
    // C-clip (vertical cable), ring connects to the backplate on +X, mouth opens -X
    ring_out = CABLE_D + 5;
    translate([-4 - ring_out / 2 + 1.5, 0, (DT_H - clip_w) / 2])
        linear_extrude(clip_w) difference() {
            circle(d = ring_out);
            circle(d = CABLE_D + 0.7);
            translate([-ring_out, -(CABLE_D - 1.5) / 2]) square([ring_out, CABLE_D - 1.5]); // snap mouth (-X)
        }
}
module head_comb(n = 4) {
    dt_tongue(); _backplate();
    bar_w = n * (CABLE_D + 3) + 3;
    translate([-4 - 8, -bar_w / 2, 0]) difference() {
        cube([10, bar_w, DT_H]);
        for (i = [0 : n - 1]) translate([-1, 3 + i * (CABLE_D + 3) + CABLE_D / 2, DT_H]) rotate([0, 90, 0]) cylinder(d = CABLE_D, h = 12); // open-top slots
        for (i = [0 : n - 1]) translate([-1, 3 + i * (CABLE_D + 3) + CABLE_D / 2, DT_H - CABLE_D / 2]) cube([12, CABLE_D, CABLE_D]);
    }
}
module head_velcro(strap_w = 25, strap_t = 3) {
    dt_tongue(); _backplate();
    translate([-4 - 6, -(strap_w + 8) / 2, 0]) difference() {
        cube([6, strap_w + 8, DT_H]);
        translate([-1, 4, DT_H / 2 - strap_t / 2]) cube([8, strap_w, strap_t]); // strap thru-slot
    }
}
