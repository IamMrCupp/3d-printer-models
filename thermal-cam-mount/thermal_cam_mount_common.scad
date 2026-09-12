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
CAM_CLR   = 0.2;
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
TRAY_TILT = 25;   // the ANGLE YOU SET ON THE BENCH — see the index below     // deg off horizontal — the reference's 14.1, rounded
BORDER    = 8;      // material around the camera pocket. 8, not 5, so the
                    //   lips stay over solid tray instead of hanging past its edge
POST_W    = 4;      // corner post footprint
// POSTS REACH THE CAMERA'S TOP AND THEN HOOK OVER IT. The first cut made them
// plain 10 mm pins: they fenced the camera at four corners and did nothing else,
// so on a 14 deg tray it slid to the low pair and lifted straight out. 10 mm did
// not even reach the 14 mm top face.
POST_H    = CAM_D + CAM_CLR;   // 14.03 — level with the camera's top face
LIP_PROJ  = 1.0;    // how far each lip reaches IN over the camera.
                    //
                    // WAS 3.0, AND THAT DESTROYED A PRINTED MOUNT. A 3 mm lip
                    // leaves a 36.56 mm opening over a 42.36 mm camera, so
                    // seating it demanded 2.90 mm of spread PER SIDE. Rigid
                    // PETG does not give 2.9 mm. The mount split into six
                    // pieces along its layer lines on the first attempt to
                    // flex the camera in.
                    //
                    // The tray-only coupon flexed fine and proved nothing: it
                    // prints FLAT, so its layers run across the bend, and it is
                    // unbraced. In the mount the tray prints on edge, layers
                    // aligned with the split, with the arm and gussets holding
                    // the very edges that have to move. Opposite mechanics from
                    // the same geometry.
                    //
                    // At 1.0 the opening is 40.56 and seating needs 0.90 mm per
                    // side - taken by the pads themselves, not by bending the
                    // frame. cam_fit_coupon now prints in the MOUNT's
                    // orientation so this is testable for 12 g.
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

// ---------------------------------------------------------------------------
// RETENTION PADS.  [x, y, w, d, radial_is_Y]
//
// These sit at the MIDDLE OF EACH EDGE, not at the corners.  The first printed
// tray fenced the pocket with four corner posts, and the camera slid freely
// inside it: the body's corners are radiused, so a 4 mm post standing in a
// corner touches nothing but air.  Contact has to land on the flat middle of a
// side, which is the one part of the outline whose position does not depend on
// a corner radius nobody has measured.
//
// The outboard edge is not free at its centre — the plug notch owns x -7..+7 —
// so that side gets a pair flanking the notch instead of one pad.
PAD_T = POST_W;                     // radial thickness of a pad
px    = POCK_W/2 + PAD_T/2;
py    = POCK_D/2 + PAD_T/2;
PADS = [
    [-px,   0, PAD_T, 10, false],   // left edge
    [ px,   0, PAD_T, 10, false],   // right edge
    [   0,  py,   12, PAD_T, true], // outboard edge — the LOW side, now unobstructed
    [ -10, -py,    6, PAD_T, true], // inboard, left of the plug notch
    [  10, -py,    6, PAD_T, true] // inboard, right of the plug notch
];


// Open tray, flat, pre-tilt. Camera lies in it; posts fence it; it looks down
// through the window. Pads fence it on the flats. +Y is OUTBOARD (away from the optical axis) — that is the
// side the plug notch is cut into.
// The pocket's retention pads and their lips, standing on z = TRAY_T. Split out
// so the yoked tray (wider in X) can reuse them on its own floor.
module _tray_bodies() {
        for (pad = PADS)
            translate([pad[0], pad[1], TRAY_T - EPS]) {
                linear_extrude(POST_H + EPS) _rr(pad[2], pad[3], 1);
                // Corbelled lip: a TAPERED EXTRUDE, not a hull. Hulling two
                // EPS-thin slabs is what produced a 6.7e-04 mm sliver here,
                // and it is the same thing that cost five attempts on the
                // arm. linear_extrude's scale gives the taper directly, with
                // nothing coincident anywhere.
                //
                // The scale is a VECTOR, and it grows on the RADIAL axis
                // only — LIP_PROJ per side over LIP_RISE, 37 deg from
                // vertical, so the underside carries itself. Growing along
                // the edge too would just eat BORDER for nothing, and on the
                // outboard pair it would close over the plug notch.
                translate([0, 0, POST_H])
                    linear_extrude(LIP_RISE,
                                   scale = [pad[4] ? 1 : (pad[2] + 2*LIP_PROJ)/pad[2],
                                            pad[4] ? (pad[3] + 2*LIP_PROJ)/pad[3] : 1])
                        _rr(pad[2], pad[3], 1);
            }
}

// The lens window and plug notch, cut through the floor.
module _tray_cuts() {
    // lens window
    translate([0, 0, -EPS]) linear_extrude(TRAY_T + 2*EPS) _rr(WIN_W, WIN_D, 4);
    // plug + lead relief, INBOARD border only, between the inboard pads.
    // The tray tilts 14 deg down toward +Y, so the INBOARD edge is the high
    // one: the plug leaves it pointing UP-slope, which is what puts the
    // device's screen where it can be seen and touched during placement.
    // Outboard would bury it under the mount, which is how the first one
    // was built.
    translate([0, -TRAY_D/4, -EPS])
        linear_extrude(TRAY_T + 2*EPS) square([PLUG_W, TRAY_D/2 + 2*EPS], center = true);
}

// The plain tray, as the fit coupon prints it.
module _tray() {
    difference() {
        union() { linear_extrude(TRAY_T) _rr(TRAY_W, TRAY_D, 3); _tray_bodies(); }
        _tray_cuts();
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
ARM_Y1 = 22;   // bar's outboard face — 2 mm further from the camera's inboard face
// ONE web. It was briefly split into two legs straddling the plug notch, on the
// belief that the notch would otherwise cut it in half. That was wrong twice
// over, and it broke a printed part:
//
//   1. The notch is subtracted INSIDE _tray(). The arm is unioned afterwards, so
//      the notch never cut the arm at all — the arm fills it where they overlap.
//      There was no collision to solve.
//   2. The split cost 44% of the section (365.6 -> 205.6 mm2) and left two
//      10.3 mm posts with 16 mm of support packed between them for the arm's
//      whole height. Prying that out snapped them off the plate.
//
// The arm's top stops INSIDE the tray's thickness, below the floor's top face,
// so it never intrudes on the camera pocket and the plug — which sits above the
// floor — clears it regardless. check_arm_clearance.py holds that line.
// TWO LEGS, DEEP ONES, WITH A GUSSET AT THE ROOT.
//
// The channel between the legs is NOT optional — the plug and cord leave the
// tray's inboard edge and pass up through it. A single web closes it and the
// camera cannot be fitted at all. That mistake was made once, by "restoring"
// the web to fix a broken arm, with no check to catch it. check_cord_path.py
// exists so it cannot happen again.
//
// What actually broke the printed part was not the split, it was the leg
// SECTION: 10.28 x 10 mm each. Depth is the free direction here — it does not
// touch the channel — so the legs run ARM_D deep instead of 10, and two of them
// now carry more section than the single web ever did:
//
//   single web        36.56 x 10 = 365.6 mm2   (no cord channel)
//   two legs, old      2 x 10.28 x 10 = 205.6 mm2
//   two legs, now      2 x 10.28 x 18 = 370.1 mm2
//
// Bending stiffness goes with depth squared, so each leg is 3.24x stiffer than
// the pair that snapped.
//
// The gusset flares that depth further over the last GUSSET_H below the plate,
// killing the sharp 90 deg corner that was both the stress riser and the thing
// the support tool levered against. It grows DOWNWARD from the plate's
// underside, never above it, so it stays out of the tab's clamped volume.
ARM_GAP    = PLUG_W + 2;                      // clear span for plug + cord
ARM_LEG    = (ARM_STRIP_W - ARM_GAP) / 2;     // 10.28 each
ARM_D      = 26;                              // leg depth in Y. Was 18 (Y 4..22);
                                              //   now Y -4..22 so the index arc,
                                              //   which swings INBOARD, lands on
                                              //   the bar. Under the plate there
                                              //   is nothing at Y -4..4 to hit.
GUSSET_H   = 8;
GUSSET_OUT = 4;
// Depth is added INBOARD only. Growing it outboard pushes the legs under the
// camera pocket and they rise into it — check_arm_clearance.py caught exactly
// that at 86 mm3. The outboard face stays at ARM_Y1 where it always was.
ARM_YC     = ARM_Y1 - ARM_D/2;                // legs span Y 6..24

// ============================================================================
// ADJUSTABLE TILT — pivot + filament-pin index
//
// The tilt was a FIXED 14 deg, inherited from a downloaded model and never
// checked against this scope. The lens sits ~43 mm outboard of the optical axis
// and at 14 the axes do not meet until 172 mm down, so the thermal view landed
// 2-3 cm off the field. Twenty-odd reprints went into guessing a fixed number.
//
// THREE THINGS THE FIRST ADJUSTABLE VERSION GOT WRONG, all shipped, all printed:
//   1. The two parts OVERLAPPED by 2,330 mm3 — a boss on the leg face with the
//      yoke face set at zero clearance from it. They could not be joined at all.
//   2. The yoke sat INSIDE the camera pocket, 1,021 mm3. The pivot was at the
//      pocket's edge, so any disc around it reached in.
//   3. 15.5 mm of yoke hung BELOW the tray floor. No clean print orientation.
// None of the per-part checks could see any of that. check_assembly.py can.
//
// SO: the yoke lives OUTBOARD of the pads (x >= YOKE_X0, beyond the lips at
// 26.28). The legs move out to sit just inside it. The index is ABOVE the pivot,
// so nothing on the tray part reaches below its own floor and it prints
// floor-down with no support.
//
// INDEXED WITH A FILAMENT PIN, not serrations and not M3 holes. Serrations need
// a full 360 deg ring, which never fit on the leg. 3.4 mm holes need a 50 mm
// radius at 5 deg just to stop merging. A 1.75 mm filament stub through 2.0 mm
// holes on a 30 deg arc at r 15 fits on the plain bar and cannot creep.
//
// Pivot is two M3s, one per side, each into a nut trap on the leg's inner face —
// coaxial by construction, no 60 mm screw.
YOKE_T     = 4;
YOKE_X0    = 26.5;                       // inner face — clear of the lips at 26.28
LEG_CLR    = 0.5;                        // running gap, leg face to yoke face
PIVOT_IN   = 2.5;                        // pivot's inset from the tray's inboard edge.
                                         //   At 8 the pivot sat ON the camera's inboard
                                         //   face and the leg's round end reached 5 mm
                                         //   into the pocket — 320 mm3 at every step.
                                         //   check_assembly caught it before a print.
PIVOT_D    = 3.4;                        // M3 clearance
PIV_LZ     = 11;                         // pivot height above the tray's underside.
                                         //   High enough that the leg's round end
                                         //   clears the floor at 45 deg — verified
                                         //   by check_assembly, not by arithmetic.
LEG_END_R  = 4.5;                        // leg ends in a half-round on the pivot
NUT_AF     = 5.6;                        // M3 nut across flats + clearance
NUT_T      = 2.6;

IDX_R      = 15;                         // index hole radius from the pivot
IDX_D      = 2.0;                        // 1.75 filament pin
TILT_MIN   = 15;
TILT_MAX   = 45;
TILT_STEP  = 10;
IDX_N      = floor((TILT_MAX - TILT_MIN)/TILT_STEP) + 1;

PIV_Y      = 18;                         // pivot axis, assembly Y
PIV_DROP   = 34;                         // pivot this far below the plate's underside
PIV_Z      = bot_z0 - PIV_DROP;

assert(TRAY_TILT >= TILT_MIN && TRAY_TILT <= TILT_MAX,
       str("TRAY_TILT ", TRAY_TILT, " is outside the indexed range ", TILT_MIN, "..", TILT_MAX));
assert((TRAY_TILT - TILT_MIN) % TILT_STEP == 0,
       str("TRAY_TILT ", TRAY_TILT, " is not on a ", TILT_STEP, " deg step"));
echo(str("tilt ", TRAY_TILT, " deg — index hole ", (TRAY_TILT - TILT_MIN)/TILT_STEP + 1, " of ", IDX_N));

// The tray is WIDER than the pocket border alone would make it: it has to reach
// out to the yoke's outer face.
TRAY_WX    = 2*(YOKE_X0 + YOKE_T);       // 61.0
PIV_LY     = -TRAY_D/2 + PIVOT_IN;       // pivot, tray-local Y

// THE INDEX ARC SWINGS INBOARD. The yoke's hole sits IDX_R INBOARD of the pivot
// along the tray, at pivot height; rotating that by -t puts the leg's hole at
// (-R cos t, +R sin t) from the pivot — inboard and slightly up, on the bar.
//
// The first version put the yoke's hole ABOVE the pivot. That swings OUTBOARD,
// to Y 24-29, past the bar's face at 22 — three of four index holes were in
// thin air, and the pin check passed because a pin through air is unblocked.
// check_assembly now also requires MATERIAL around every hole.
function idx_at(t) = [PIV_Y - IDX_R*cos(t), PIV_Z + IDX_R*sin(t)];

// One yoke paddle in the Y-Z plane (2D), pivot at (PIV_LY, PIV_LZ).
module _yoke_2d() {
    difference() {
        hull() {
            translate([PIV_LY, PIV_LZ]) circle(r = 6.5, $fn = 64);
            translate([PIV_LY - IDX_R, PIV_LZ]) circle(r = 5.0, $fn = 64);
            // a foot along the floor so it unions into the tray body
            translate([PIV_LY - 6.5, 0]) square([13, TRAY_T]);
        }
        translate([PIV_LY, PIV_LZ]) circle(d = PIVOT_D, $fn = 32);
        translate([PIV_LY - IDX_R, PIV_LZ]) circle(d = IDX_D, $fn = 24);
    }
}

// The yoke WITHOUT its holes — check_assembly probes this to prove there is
// material around the index hole, not just an unblocked path through air.
module _yoke_2d_solid() {
    hull() {
        translate([PIV_LY, PIV_LZ]) circle(r = 6.5, $fn = 64);
        translate([PIV_LY - IDX_R, PIV_LZ]) circle(r = 5.0, $fn = 64);
        translate([PIV_LY - 6.5, 0]) square([13, TRAY_T]);
    }
}
module _tray_yoked_solid() {
    for (sx = [-1, 1])
        translate([sx > 0 ? YOKE_X0 : -YOKE_X0 - YOKE_T, 0, 0])
            rotate([90, 0, 90]) linear_extrude(YOKE_T) _yoke_2d_solid();
}

// The tray part: the tray (widened in X) plus two yoke paddles standing on it.
module _tray_yoked() {
    union() {
        difference() {
            union() {
                linear_extrude(TRAY_T) _rr(TRAY_WX, TRAY_D, 3);
                _tray_bodies();
            }
            _tray_cuts();
        }
        for (sx = [-1, 1])
            translate([sx > 0 ? YOKE_X0 : -YOKE_X0 - YOKE_T, 0, 0])
                rotate([90, 0, 90])
                    linear_extrude(YOKE_T)
                        _yoke_2d();
    }
}

// The tray, hung off the pivot at tilt t.
module _tray_at(t) {
    translate([0, PIV_Y, PIV_Z])
        rotate([-t, 0, 0])
            translate([0, -PIV_LY, -PIV_LZ])
                _tray_yoked();
}

// Legs: bars from the plate down to a half-round end centred on the pivot,
// carrying the pivot bore, a nut trap on the inner face, and the index arc.
LEG_XO = YOKE_X0 - LEG_CLR;              // leg outer face 26.0
LEG_XI = LEG_XO - ARM_LEG;               // leg inner face 15.72
module _legs() {
    for (sx = [-1, 1]) {
        xi = sx > 0 ? LEG_XI : -LEG_XO;
        translate([xi, 0, 0]) {
            // bar, from just above the pivot up into the plate
            translate([0, ARM_YC - ARM_D/2, PIV_Z]) cube([ARM_LEG, ARM_D, (bot_z0 + 4) - PIV_Z]);
            // round end on the pivot, overlapping the bar's foot
            translate([0, PIV_Y, PIV_Z]) rotate([0, 90, 0])
                cylinder(r = LEG_END_R, h = ARM_LEG, $fn = 48);
            // gusset into the plate
            translate([ARM_LEG/2, ARM_YC, bot_z0 - GUSSET_H])
                linear_extrude(GUSSET_H, scale = [1, (ARM_D + 2*GUSSET_OUT)/ARM_D])
                    square([ARM_LEG, ARM_D], center = true);
        }
    }
}
module _leg_cuts() {
    L = 200;
    // pivot bore, both legs
    translate([-L/2, PIV_Y, PIV_Z]) rotate([0, 90, 0]) cylinder(d = PIVOT_D, h = L, $fn = 32);
    // nut traps on the INNER faces (the screws come in from outside the yokes)
    for (sx = [-1, 1])
        translate([sx > 0 ? LEG_XI - EPS : -LEG_XI - NUT_T + EPS, PIV_Y, PIV_Z])
            rotate([0, 90, 0]) cylinder(d = NUT_AF/cos(30), h = NUT_T + EPS, $fn = 6);
    // the index arc
    for (i = [0 : IDX_N-1]) {
        p = idx_at(TILT_MIN + i*TILT_STEP);
        translate([-L/2, p[0], p[1]]) rotate([0, 90, 0]) cylinder(d = IDX_D, h = L, $fn = 24);
    }
}
module _arm() { difference() { _legs(); _leg_cuts(); } }

// ---- part 1: bottom plate + bosses ----
module mount_bottom() {
    // The tray is its OWN part now — see mount_tray.scad. This piece never
    // changes when the angle does.
    if (TRAY_BELOW) _arm();
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
        if (!TRAY_BELOW) _arm();
    }
}
