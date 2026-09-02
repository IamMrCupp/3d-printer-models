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

// ---- Sipeed T256s — CALIPERED 2026-09-01 ----
//
// 42 x 35 x 14 was a DATASHEET figure. The user's own 2026-07-22 notes label that
// line "(spec)", and survey/MEASUREMENTS.md carried it as ✅ regardless. Every
// version of this mount cut its pocket from it.
//
// Real body on calipers: W +0.36, H -0.65, D -0.57 against spec. Small numbers,
// but the pocket cut from spec ran 1.25 mm loose across the short axis while
// leaving only 0.24 mm on the long one — slop one way and a near interference the
// other, from the same wrong pair.
CAM_W = 42.36; CAM_H = 34.35; CAM_D = 13.43;
CAM_CLR   = 0.6;
CAM_ANGLE = 30;   // tilt from vertical → lens looks down at the board

// ---- TRAY (2026-08-31) — replaces the upright cradle -----------------------
//
// The camera LIES FLAT in an open tray and looks straight down through a window,
// instead of standing upright in a cradle tilted 60 deg. Modelled on the
// reference the user supplied (Thermal Camera Mount type 3 v3.2): open tray,
// round lens window, corner posts, shallow tilt.
//
// THIS IS WHAT FIXES THE CABLE. The old cradle stood the camera up and tilted it
// 60 deg, which aimed its top edge — where the male plug and the live cable are
// — at (0, -0.87, +0.50): up and INWARD, straight at the scope's objective. Lying
// flat, the plug edge points sideways, and WHICH sideways is a free choice. It is
// set OUTBOARD, away from the optical axis, and the tray's outboard border is
// notched so the plug and lead drop clear.
//
// Only the CRADLE is replaced. The sandwich clamp on the control-box tab
// (49.65 x 32.51 x 26.42) is unchanged — that half was never the problem.
TRAY_T    = 3.0;    // tray thickness — the reference's
TRAY_TILT = 14;     // deg off horizontal — the reference's 14.1, rounded
BORDER    = 8;      // material around the camera pocket. 8, not 5, so the
                    //   lips stay over solid tray instead of hanging past its edge
POST_W    = 4;      // corner post footprint
// POSTS REACH THE CAMERA'S TOP AND THEN HOOK OVER IT. The first cut made them
// plain 10 mm pins: they fenced the camera at four corners and did nothing else,
// so on a 14 deg tray it slid to the low pair and lifted straight out. 10 mm did
// not even reach the 14 mm top face.
POST_H    = CAM_D + CAM_CLR;   // 14.03 — level with the camera's top face
LIP_PROJ  = 3.0;    // how far each lip reaches IN over the camera
LIP_RISE  = 4.0;    // 3 over 4 -> 37 deg from vertical, so the lip's underside
                    //   carries itself and needs no support

PLUG_W    = 14;     // relief notch for the male plug + lead, OUTBOARD side

// ⚠️ THE WINDOW IS DELIBERATELY OVERSIZE. The notes record the thermal lens as
// "offset toward LEFT" and the offset itself has never been measured. A window
// cut to a guessed centre would blind the camera, and no mesh check catches a
// part that is the right shape over the wrong spot. 34 x 26 in a 42 x 35 body
// leaves a 4 mm border all round and clears the optic wherever it actually sits.
// Wrong in the safe direction, like the heat-gun plate's head recesses.
WIN_W = 34; WIN_D = 26;

// 26, NOT the cradle's old 19.5. At 19.5 the BOTTOM clamp plate clipped the
// innermost 3.8 mm of the lens window about 35 mm down — the camera could not
// see the part of the board nearest the objective, which is the only part worth
// seeing. Swept against the real sight line: blocked at 19.5 and 22, clear from
// 24. 26 leaves 2 mm of margin.
//
// The alternative was flattening TRAY_TILT to 8 (also clear at 19.5), but that
// aims the lens nearer straight down and gives up inward coverage. Reaching
// further out costs 6.5 mm of offset against a 175 mm field — nothing.
ARM_FWD = 26;       // tray centre forward of the tab's front face
// THE TRAY HANGS BELOW THE BOTTOM PLATE. The control housing sits BEHIND the
// lights and the space under it is clear (user, 2026-08-31, after sending photos
// repeatedly). The old header claim that "everything below the tab is the
// working volume" was simply wrong, and it is what pushed the camera up top.
//
// Below is the better place: it drops the camera ~34 mm, much closer to the
// objective's plane, which cuts the parallax the HUD registration has to correct.
// The pre-2026-08-08 version that hung below failed on an INVERTED TILT SIGN
// that aimed the lens up into the objective — a real bug that got blamed on the
// position. A flat tray looking down through a window cannot repeat it.
TRAY_BELOW = true;
ARM_UP  = 3;        // used only when TRAY_BELOW is false

TRAY_W = CAM_W + CAM_CLR + 2*BORDER;    // 52.6
TRAY_D = CAM_H + CAM_CLR + 2*BORDER;    // 45.6
POCK_W = CAM_W + CAM_CLR;
POCK_D = CAM_H + CAM_CLR;

// ============================================================================
// derived
half    = TAB_T/2 + FIT/2;                 // inner half-gap (plate face to centre)
y_front = TAB_FB/2;
y_back  = y_front - GRIP_LEN;
PW      = 2*(TAB_W/2 + BOSS_GAP + 2*BOSS_R);   // plate width (spans to the bosses)
boss_x  = TAB_W/2 + BOSS_GAP + BOSS_R;
boss_y  = y_front - BOSS_INSET_Y;
bot_z0  = -half - PLATE_T;                  // underside of the bottom plate
top_z1  = half + PLATE_T;                   // top face of the top plate
cr_y    = y_front + ARM_FWD;                // tray origin, pre-rotation
// Hanging below, the camera sits BETWEEN the tray and the bottom plate, so the
// drop has to clear the tray's own inboard rise plus the camera's full depth.
TRAY_DROP = (TRAY_D/2)*sin(TRAY_TILT) + (TRAY_T + CAM_D + CAM_CLR)*cos(TRAY_TILT) + 3;
cr_z    = TRAY_BELOW ? bot_z0 - TRAY_DROP : top_z1 + ARM_UP;

module _plate() {                            // flat footprint in X-Y, unit thickness at z=0
    translate([-PW/2, y_back, 0]) cube([PW, GRIP_LEN, PLATE_T]);
}

module _rr(w, d, r) { offset(r) offset(-r) square([w, d], center = true); }

// Open tray, flat, pre-tilt. Camera lies in it; posts fence it; it looks down
// through the window. +Y is OUTBOARD (away from the optical axis) — that is the
// side the plug notch is cut into.
module _tray() {
    difference() {
        union() {
            linear_extrude(TRAY_T) _rr(TRAY_W, TRAY_D, 3);
            for (sx = [-1, 1], sy = [-1, 1])
                translate([sx*(POCK_W/2 + POST_W/2), sy*(POCK_D/2 + POST_W/2), TRAY_T - EPS]) {
                    linear_extrude(POST_H + EPS) _rr(POST_W, POST_W, 1);
                    // Corbelled lip: a TAPERED EXTRUDE, not a hull. Hulling two
                    // EPS-thin slabs is what produced a 6.7e-04 mm sliver here,
                    // and it is the same thing that cost five attempts on the
                    // arm. linear_extrude's scale gives the taper directly, with
                    // nothing coincident anywhere.
                    //
                    // It grows LIP_PROJ on every side over LIP_RISE — 3 over 4,
                    // 37 deg from vertical, so the underside carries itself. The
                    // inward growth is what hooks over the camera; the outward
                    // growth is why BORDER is 8.
                    translate([0, 0, POST_H])
                        linear_extrude(LIP_RISE, scale = (POST_W + 2*LIP_PROJ)/POST_W)
                            _rr(POST_W, POST_W, 1);
                }
        }
        // lens window
        translate([0, 0, -EPS]) linear_extrude(TRAY_T + 2*EPS) _rr(WIN_W, WIN_D, 4);
        // plug + lead relief, OUTBOARD border only, clear of the corner posts
        translate([0, TRAY_D/4, -EPS])
            linear_extrude(TRAY_T + 2*EPS) square([PLUG_W, TRAY_D/2 + 2*EPS], center = true);
    }
}

// Arm: carries the tray up off the TOP plate and forward of the tab's front
// face.
//
// IT MEETS THE TRAY AT ITS INBOARD EDGE, NOT UNDERNEATH IT. Two reasons, and the
// first one is fatal:
//   1. A hull reaching the tray's full footprint sits directly under the lens
//      window and blinds the camera.
//   2. Matching the tray's outline exactly made the hull's side walls arrive
//      TANGENT to the tray's side walls along their whole length — 10
//      non-manifold edges on the seam at x = +-26.3. A square patch of the same
//      size was no better: its corners stood proud of the tray's rounded ones,
//      for 4 edges. Landing on the edge strip avoids both.
//
// The strip is 8 mm narrower than the tray so it stays inside the flat part of
// the outline and never interacts with the corner radii.
ARM_STRIP = 6;      // depth of the landing strip along the tray's inboard edge
// ...and it must stay clear of the INBOARD POSTS, whose inner faces sit at
// |x| = POCK_W/2 = 21.3. A strip wide enough to reach them makes the hull's
// surface graze the post walls, which stitched 2 non-manifold edges at
// x = -22.3. 36.6 leaves 3 mm either side.
ARM_STRIP_W = POCK_W - 6;
// Arm: a plain upright web from the top plate into the tray's inboard edge.
//
// NO hull(). Five attempts at hulling to the tilted tray produced five different
// degeneracies — corners proud of the rounded outline (4 edges), a tangent
// arrival on the side walls (10), three faces on one line (2), a zero-length
// edge, and again with solid blocks. Bisection put it on the arm-to-tray join
// every time; the tray alone and the arm alone always passed.
//
// A box has flat faces. Where it meets the tilted tray, two planes cross at 14
// deg — an honest intersection with nothing coincident, coplanar or tangent.
// It buries 4 mm into the top plate at the bottom and stops inside the tray's
// thickness at the top.
// The web spans Y 14..24. That overlaps the plate (which ends at y_front 16.26)
// at its inboard end, and at its outboard end maps to tray-frame y -18.8 —
// still INBOARD of the camera pocket's edge at -17.8, so it never intrudes on
// the camera.
ARM_Y0 = 14;
ARM_Y1 = 24;
module _arm() {
    z0 = TRAY_BELOW ? cr_z + (TRAY_D/2)*sin(TRAY_TILT) + TRAY_T/2 : top_z1 - 4;
    z1 = TRAY_BELOW ? bot_z0 + 4 : 28.5;
    translate([-ARM_STRIP_W/2, ARM_Y0, z0])
        cube([ARM_STRIP_W, ARM_Y1 - ARM_Y0, z1 - z0]);
}

// ---- part 1: bottom plate + bosses ----
module mount_bottom() {
    if (TRAY_BELOW) { _arm(); translate([0, cr_y, cr_z]) rotate([-TRAY_TILT,0,0]) _tray(); }
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
    }
}

// ---- part 2: top plate + arm + cradle ----
module mount_top() {
    union() {
        difference() {
            translate([0,0,half]) _plate();
            for (sx = [-boss_x, boss_x]) translate([sx, boss_y, half - EPS]) {
                cylinder(d = SCREW_D, h = PLATE_T + 2*EPS);
                // h is 1.6 + 2*EPS, not 1.6 + EPS. At 1.6 + EPS the counterbore's
                // top face lands EXACTLY on the plate's top face, and OpenSCAD
                // 2021.01 — what CI runs — turns that coincidence into one
                // non-manifold edge per facet: 2 holes x $fn 48 = 96, plus a
                // 1.9e-06 mm sliver. Local 2026.06 renders it clean, which is how
                // this branch sat red since August. A cut must pass THROUGH the
                // face it exits, never stop on it.
                translate([0,0,PLATE_T - 1.6]) cylinder(d = SCREW_CB, h = 1.6 + 2*EPS);
            }
        }
        if (!TRAY_BELOW) { _arm(); translate([0, cr_y, cr_z]) rotate([-TRAY_TILT,0,0]) _tray(); }
    }
}
