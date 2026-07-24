// thermal_cam_mount_common.scad — clamp a Sipeed T256s thermal camera onto the
// LED-56S ring light's control-box tab, for the benchhud thermal-fusion HUD.
//
// WHY THIS MOUNT EXISTS: the T256s is registered onto the scope's visible feed
// so a hot component's bloom labels that component. Registration is computed
// once and must HOLD every session — so the mount has to be rigid, non-drifting,
// and fixed-angle. Wobble = re-calibrate every sit-down. This is the physical
// half of the registration problem.
//
// ── ONE PLACEHOLDER LEFT ──────────────────────────────────────────────────
//   TAB_T (tab front-to-back thickness) is NOT yet measured. Everything else is
//   off calipers or the mounted-in-place photos. Set TAB_T and re-render; that
//   is the single change between this skeleton and a printable clamp.
// ──────────────────────────────────────────────────────────────────────────
//
// FRAME: tab extends +Y radially out from the ring (ring at -Y). Tab cross-
// section is X (width) × Z (thickness). Diffuser/top face at +Z, board-facing
// bottom at -Z. The cam hangs below (-Z) with its screen toward +Y (the user)
// and its USB-C cable exiting straight down (female/bottom port — confirmed by
// the mounted photos).

$fn = 64;
EPS = 0.1;   // union overlap / cut overrun so booleans stay manifold

// ---- LED-56S control-box tab (MEASURED except TAB_T) ----
TAB_W   = 49.65;   // measured across the tab
TAB_T   = 14.0;    // ⚠ PLACEHOLDER — front-to-back thickness. MEASURE + replace.
TAB_CLR = 0.6;     // clamp bore clearance around the tab

// The rocker switch is ~18 mm from the tab's outer end (front face); the 12 V
// barrel jack is on one side. The band grips near the ring ROOT, clear of both.
// It must grip the rigid ABS control-box, NOT the frosted diffuser lip.
BAND_Y0    = 2;    // start of the band, out from the ring root
BAND_DEPTH = 12;   // radial length of tab the band grips
BAND_WALL  = 3.2;
PINCH_D    = 3.4;  // M3 pinch bolt — split sleeve tightens rather than sliding
PINCH_AF   = 5.6;  // over the switch

// ---- Sipeed T256s (LOCKED) ----
CAM_W = 42; CAM_H = 35; CAM_D = 14;   // horizontal × vertical × depth (body)
CAM_CLR   = 0.6;
CAM_ANGLE = 30;    // tilt from vertical → thermal lens looks roughly down at the board

// ---- open cradle (grip edges/corners; alu body is the heatsink; screen visible) ----
LIP     = 4.5;     // bottom-edge catch that the cam sits into
SIDE_H  = 14;      // how far side walls rise up the 35 mm cam height
CORNER  = 6;       // top-corner inturned catches
CABLE_W = 12;      // bottom cable slot (USB-C exits down)
WALL    = 3;

// ---- arm ----
ARM_DROP = 6;      // short — the cam sits just below the tab

// ============================================================================

// Clamp sleeve around the tab cross-section. SKELETON: a plain closed sleeve to
// show the concept. The finished part becomes a split sleeve with an M3 pinch
// bolt so it clips on radially rather than sliding over the switch — that split
// is placed once a straight-on shot of the tab underside pins the switch/jack
// footprint. (PINCH_D / PINCH_AF are reserved for it.)
module _tab_clamp() {
    bw = TAB_W + TAB_CLR; bt = TAB_T + TAB_CLR;
    ow = bw + 2*BAND_WALL; ot = bt + 2*BAND_WALL;
    translate([0, BAND_Y0, 0]) rotate([-90,0,0])
        linear_extrude(BAND_DEPTH) difference() {
            offset(2) offset(-2) square([ow, ot], center=true);   // rounded outer
            square([bw, bt], center=true);                         // tab bore
        }
}

// Open cradle in its own upright frame (before the downward tilt): a back plate
// (behind the screen) + bottom lip + two side walls + top-front corner catches.
// Grips bottom edge, both sides, and the top corners; the lens face (front) and
// most of the screen (back) stay open, and the alu body heatsinks freely.
module _cradle() {
    iw = CAM_W + CAM_CLR; id = CAM_D + CAM_CLR;
    ow = iw + 2*WALL; oy = id + 2*WALL;
    difference() {
        union() {
            // bottom tray
            translate([-ow/2, 0, 0]) cube([ow, oy, LIP]);
            // two side walls (overlap the tray in z)
            translate([-ow/2, 0, 0]) cube([WALL, oy, SIDE_H]);
            translate([ iw/2, 0, 0]) cube([WALL, oy, SIDE_H]);
            // back plate behind the screen (overlaps both side walls in y)
            translate([-ow/2, oy - WALL, 0]) cube([ow, WALL, SIDE_H + WALL]);
            // top-front corner catches — sit on top of the side walls (overlap in x+z)
            for (sx = [-ow/2, iw/2 - CORNER]) translate([sx, 0, SIDE_H - EPS]) cube([WALL + CORNER, WALL + 2, WALL + EPS]);
        }
        // cam body cavity (overruns top so the cam drops in)
        translate([-iw/2, WALL, LIP]) cube([iw, id, CAM_H + CAM_CLR + 10]);
        // bottom cable slot (USB-C exits straight down)
        translate([-CABLE_W/2, -EPS, -EPS]) cube([CABLE_W, oy + 2*EPS, LIP + 2*EPS]);
    }
}

module thermal_cam_mount() {
    bt = TAB_T + TAB_CLR;
    ow = TAB_W + TAB_CLR + 2*BAND_WALL;
    clamp_bottom = -bt/2 - BAND_WALL;           // -Z underside of the band
    yc = BAND_Y0 + BAND_DEPTH/2;                // band mid-length
    union() {
        _tab_clamp();
        // arm: a solid block bridging from inside the band's underside down to
        // the cradle. Inset from the clamp's outer width so their side faces
        // don't coincide (coplanar faces = non-manifold), and tall enough to
        // overlap the sleeve's bottom wall in volume so the union is one body.
        aw = ow - BAND_WALL;
        translate([-aw/2, BAND_Y0, clamp_bottom - ARM_DROP])
            cube([aw, BAND_DEPTH, ARM_DROP + BAND_WALL + EPS]);
        // cradle, tilted so the lens aims down-and-out toward the board
        translate([0, yc + BAND_DEPTH/2 - EPS, clamp_bottom - ARM_DROP])
            rotate([-(90 - CAM_ANGLE), 0, 0]) _cradle();
    }
}

// leaf part files call thermal_cam_mount(); this common defines only.
