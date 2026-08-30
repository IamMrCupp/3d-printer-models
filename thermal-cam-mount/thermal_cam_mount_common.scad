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
// SIDE_H IS THE WHOLE BALLGAME. It was 16, and that is why the printed part did
// not hold the camera.
//
// The camera sits on the LIP, so it spans z 4.50 .. 39.50 and its centre of mass
// is at z 22.00. At SIDE_H 16 every retaining feature — side walls, back wall,
// and the front corner tabs that sit on top of the walls — topped out at z 19.00.
// Measured off the mesh, not eyeballed:
//
//     material in front of the camera   z  0.00 .. 19.00
//     material beside it                z  0.00 .. 19.00
//     material behind it                z  0.00 .. 19.00
//     camera                            z  4.50 .. 39.50   CoM z 22.00
//
// Every grip below the centre of mass, on a cradle tilted 60 deg so that gravity
// pulls the body out the open front (the local -Y component of gravity after the
// tilt is 0.87). The camera pivots over the top of the walls and levers itself
// out. Nothing could catch this: the mesh is valid, and verify_aim.py checks the
// lens ANGLE, which was right the whole time.
//
// 30 puts the corner tabs at z 30 .. 33 — above the centre of mass — and takes
// the side-wall grip from 14.5 mm of the 35 mm body to 25.5 mm.
SIDE_H = 30;
// The back wall stays where it was. It is the only solid face against the 1.69"
// screen, and raising it with the sides would bury the screen the open cradle
// exists to keep visible. It also is not the face doing the work: gravity pushes
// the camera FORWARD out of this cradle, so the front tabs are what retain it.
BACK_H = 19;
LIP=4.5; CORNER=6; CABLE_W=12; WALL=3;
TAB_PROJ = CORNER;      // how far a retaining tab reaches over the pocket
TAB_RISE = TAB_PROJ + 1;// 7 over 6 -> 40.6 deg from vertical, self-supporting
// PORT: the camera runs off its MALE plug, which is on the TOP edge (user,
// 2026-08-28). The plug protrudes ~7 mm, so with the body at z 4.50..39.50 the
// plug and its right-angle adapter live at z 39.50..46.50 — above the cradle
// entirely, nothing to model. The floor slot that used to be cut for a
// bottom-port cable is therefore NOT cut: a continuous lip is more seat for the
// camera to stand on, and the slot was never load-bearing.
CABLE_DIR = "top";    // "top" (male/top port, live cable above) | "down" | "side"

// ---- cradle placement — ABOVE the plate, looking DOWN and INWARD -----------
// The tab is COPLANAR with the ring light's disc. So everything below the tab
// is the working volume between the objective and the board — the cam must
// never go there. It rides ABOVE the top plate, just outboard of the tab's
// front face, and sights down past the plate's front-top corner at the board.
//
// FIXED 2026-08-08: the cradle used to hang BELOW the bottom plate, rotated
// -(90-CAM_ANGLE). That put the cam in the working volume AND aimed the lens
// 60 deg UP into the objective. Both are corrected here; verify_aim.py checks
// the lens vector and the corner clearance so this can't regress silently.
TILT    = 90 - CAM_ANGLE;   // +60 -> lens points DOWN and inward (sign was inverted)
ARM_FWD = 19.5;             // cradle origin forward of the tab's front face
ARM_UP  = 0;                // cradle base above the top plate's top face

// ---- adjustable tilt (INDEXED, not friction) -------------------------------
// The cradle is a separate part now, joined to the arm by a pivot screw and a
// second screw through one of a row of index holes.
//
// A CLAMPED ARC SLOT, NOT A ROW OF INDEX HOLES. Index holes were tried first,
// on the reasoning that a clamped joint might creep and quietly invalidate the
// registration. Both halves of that were wrong:
//
//   - They do not fit. At IDX_R 11 a 5 deg step is 0.96 mm of arc and an M3
//     clearance hole is 3.4 mm wide, so the holes merge into a continuous slot
//     anyway. Getting a 2 mm web between them needs IDX_R ~62, a 124 mm disc.
//     A probe at 32.5 deg — deliberately between two "holes" — came back open,
//     which is what exposed it.
//   - The creep worry does not survive arithmetic. An M3 hand-tight in PETG
//     holds on the order of 1.6 N.m of friction at this radius. The camera's
//     gravity torque about the pivot is ~0.006 N.m. That is ~250x margin.
//
// So: continuous adjustment over the range, locked by the pivot screw and the
// slot screw together.
//
// Splitting the parts also gets rid of the support problem: the cradle no longer
// prints fused to the plate at 60 deg.
// RANGE IS 30..55, NOT 15..55, AND THE FLOOR IS GEOMETRY NOT TASTE. Below 30 the
// top plate's own front-top corner clips the bottom of the camera's 42 deg
// vertical FOV — at 25 the lower ray crosses the corner plane 19 mm low. Swept
// every position with verify_aim.py; 30 clears by +1.30 mm and it only improves
// from there. You do not need shallower: at 165 mm the thermal sees a
// 175 x 127 mm patch, so the objective's spot stays well in frame.
CAM_ANGLE_MIN = 30; CAM_ANGLE_MAX = 55; CAM_ANGLE_STEP = 5;   // reporting granularity for verify_aim's sweep only
PAD_T   = 6;      // thickness of each half of the joint (>= an M3 insert's length)
// PAD_R IS 12, NOT 16, AND THE CONSTRAINT IS SCREW ACCESS. At 16 the pad's rear
// edge sat at y 11.92 while the right clamp screw's counterbore reaches y 13.46,
// so 23.19 mm of pad sat on top of a screw that holds the whole mount on — the
// part could not be assembled. A render showed one counterbore where there
// should be two; a driver-access probe confirmed it.
//
// Moving the arm FORWARD instead was tried and is the wrong lever: it fixed the
// screw and broke the aim. A lens further out has further to travel back to the
// plate's corner plane, so it has dropped further by the time it gets there —
// clearance at 30 deg went from +1.30 to -20.80. Shrinking the pad fixes the
// screw and leaves the aim untouched.
//
// 12 puts the pad's rear at y 15.92, clear of the counterbore by 2.5 mm.
PAD_R   = 12;     // joint pad radius
IDX_R   = 8;      // slot radius about the pivot — must leave PAD_R a rim:
                  // IDX_R + SLOT_W/2 = 10 against a 12 pad. Friction torque
                  // scales with it and is ~1.2 N.m here against 0.006 needed.
M3_CLR  = 3.4;
M3_SHANK = 3.0;   // the actual screw, for working out how far it can over-travel
SLOT_W  = M3_CLR + 0.6;
PIV_Z   = 15;     // pivot height in the CRADLE's own frame — mid side-wall
// Inset the slot's end bores by the screw's over-travel, LESS a small margin so
// the nominal end angles are actually reachable rather than a zero-clearance
// tangent. The margin costs 0.4 deg of over-travel at each end, which bottoms
// out at 29.6 deg — still +0.52 mm clear of the plate corner. The floor is
// steep: 29.0 is already -0.79 and fails, so this is deliberately tight.
SLOT_REACH = 0.4;
SLOT_INSET = ((SLOT_W - M3_SHANK)/2 / IDX_R) * 180 / PI - SLOT_REACH;   // 2.20 deg

assert(CAM_ANGLE >= CAM_ANGLE_MIN && CAM_ANGLE <= CAM_ANGLE_MAX, "CAM_ANGLE outside the index range");
assert((CAM_ANGLE - CAM_ANGLE_MIN) % CAM_ANGLE_STEP == 0, "CAM_ANGLE is not on an index position");

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
cr_y    = y_front + ARM_FWD;                // cradle origin, pre-rotation
cr_z    = top_z1 + ARM_UP;

CR_IW = CAM_W + CAM_CLR;  CR_ID = CAM_D + CAM_CLR;
CR_OW = CR_IW + 2*WALL;   CR_OY = CR_ID + 2*WALL;

// The pivot lives at (0, CR_OY/2, PIV_Z) in the CRADLE's own frame. Its world
// position is derived at REF_TILT so that at CAM_ANGLE 30 the cradle lands in
// exactly the pose the fixed-arm version put it in — the aim that verify_aim.py
// already passes. Changing CAM_ANGLE now swings the cradle about this point
// instead of moving it.
REF_TILT = 60;
PIV_WY = cr_y + (CR_OY/2)*cos(REF_TILT) - PIV_Z*sin(REF_TILT);
PIV_WZ = cr_z + (CR_OY/2)*sin(REF_TILT) + PIV_Z*cos(REF_TILT);
PAD_X  = CR_OW/2;          // cradle pad inboard face; arm pad sits outboard of it
// The top plate grows a short tongue past the tab's front face, under the arm's
// footprint only, so the arm has somewhere to stand that is forward of the
// screw boss. Without it the arm's hull has to start behind the boss and the
// convex hull closes back over it.
ARM_TONGUE = 8;

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
            translate([-ow/2, oy - WALL, 0]) cube([ow, WALL, BACK_H]);
            // Retaining tabs, CORBELLED so they carry themselves.
            //
            // They used to be plain slabs sitting on the wall tops, projecting
            // 6 mm straight over the pocket at z 30. That is a 36 mm2 flat
            // CEILING 30 mm in the air, and it is on the one feature that stops
            // the camera falling out — exactly the wrong place to accept droop.
            // It was 2.7% of the part's surface, which is why it got waved
            // through as "no supports"; area is the wrong way to judge a
            // ceiling.
            //
            // Now each tab starts flush with the wall at z=SIDE_H and reaches
            // its full projection at z=SIDE_H+TAB_RISE, so its underside is a
            // ramp at 40.6 deg from vertical — inside the 45 deg a printer
            // carries unaided. Retention improves rather than suffers: the
            // bearing edge moves UP to 37, further above the camera's centre of
            // mass at 22. Insertion gets easier too, because the gap between the
            // tabs now opens from 30.6 mm at the top to the full 42.6 at z=30
            // instead of being a hard step.
            for (s = [-1, 1])
                hull() {
                    translate([s < 0 ? -ow/2 : iw/2, 0, SIDE_H - EPS])
                        cube([WALL, WALL + 2, TAB_RISE + EPS]);
                    translate([s < 0 ? -ow/2 : iw/2 - TAB_PROJ, 0, SIDE_H + TAB_RISE - EPS])
                        cube([WALL + TAB_PROJ, WALL + 2, EPS]);
                }
        }
        translate([-iw/2, WALL, LIP]) cube([iw, id, CAM_H + CAM_CLR + 10]);
        if (CABLE_DIR == "down")
            translate([-CABLE_W/2, -EPS, -EPS]) cube([CABLE_W, oy + 2*EPS, LIP + 2*EPS]);
        else if (CABLE_DIR == "side")
            translate([-ow/2 - EPS, oy/2 - CABLE_W/2, -EPS]) cube([ow + 2*EPS, CABLE_W, LIP + 2*EPS]);
        // "top": nothing — the cable leaves above the cradle
    }
}

// Joint pad on the CRADLE, in the cradle's own frame. Sits just outboard of the
// right side wall — right, because the notes put the thermal lens offset to the
// LEFT and the pad must not shadow it.
module _cradle_pad_solid() {
    translate([PAD_X, CR_OY/2, PIV_Z]) rotate([0,90,0]) cylinder(r = PAD_R, h = PAD_T);
}

// Foot under the joint pad.
//
// The pad is a disc standing on edge, cantilevered off the side wall, and its
// lowest point is 3 mm above the bed with NOTHING under it. The bottom of a
// circle is a horizontal surface, so that was 18.8 mm2 of near-flat ceiling
// (86 deg) printing into air — a curl-and-knock failure, not cosmetic droop.
// The overhang-percentage metric missed it because 2.2% of surface area sounds
// like nothing; area is the wrong way to judge a ceiling.
//
// The foot carries the disc down to the bed, tapering outward at ~33 deg from
// vertical so it needs no help itself. It also earns its place structurally:
// the pad carries the whole camera load, and it was previously joined to the
// cradle only across its overlap with the wall.
PAD_FOOT_H = 6.5;   // above this the disc's own surface is shallower than 45 deg
module _pad_foot() {
    top_hw = sqrt(PAD_R*PAD_R - (PIV_Z - PAD_FOOT_H)*(PIV_Z - PAD_FOOT_H));
    hull() {
        translate([PAD_X, CR_OY/2 - 4.3, 0]) cube([PAD_T, 8.6, EPS]);
        translate([PAD_X, CR_OY/2 - top_hw, PAD_FOOT_H - EPS]) cube([PAD_T, 2*top_hw, EPS]);
    }
}

// Bores are cut from the FINISHED union, not from the disc alone — the foot
// reaches z 6.5 and the index insert's bore spans 4.7..9.3, so cutting the disc
// first would leave the foot filling the bottom of that bore.
module _cradle_pad_bores() {
    for (p = [[0,0], [0,-IDX_R]])
        translate([PAD_X - EPS, CR_OY/2 + p[0], PIV_Z + p[1]])
            rotate([0,90,0]) cylinder(d = INSERT_D, h = PAD_T + 2*EPS);
}

// Arm: carries the joint pad up off the TOP plate, forward of the tab's front
// face. Hulled from a patch of the plate's top face so the pad is fully backed.
// The pad's underside sits ~0.4 mm above the plate, so this is a short, stiff
// wedge rather than a cantilever.
module _arm() {
    difference() {
        hull() {
            translate([PAD_X + PAD_T, y_front, top_z1 - EPS]) cube([PAD_T, ARM_TONGUE, EPS]);
            translate([PAD_X + PAD_T, PIV_WY, PIV_WZ]) rotate([0,90,0]) cylinder(r = PAD_R, h = PAD_T);
        }
        // pivot
        translate([PAD_X + PAD_T - EPS, PIV_WY, PIV_WZ])
            rotate([0,90,0]) cylinder(d = M3_CLR, h = PAD_T + 2*EPS);
        // The slot is a single HULL of the two end bores, not a chain of
        // overlapping ones along the arc. The chain produced a 1.5e-04 mm sliver
        // triangle — dozens of near-tangent bores is exactly the near-parallel
        // boundary case that breaks on 2021.01.
        //
        // A straight slot is fine here because the travel is tiny: 25 deg at
        // IDX_R 11 is 4.8 mm of arc, and the true arc bulges only 0.26 mm off
        // that chord. SLOT_W is M3_CLR + 0.6 to swallow it — the screw centre
        // may wander 0.5 mm off the slot's axis, twice what the arc asks for.
        // END CENTRES ARE INSET, so the REACHABLE range is exactly
        // CAM_ANGLE_MIN..MAX. Hulling bores centred on MIN and MAX instead lets
        // the screw sit 0.5 mm past each end — 2.6 deg at IDX_R 11 — and a probe
        // found it would set 28 deg, which is below the floor where the top
        // plate's corner starts clipping the FOV. A joint must not offer a
        // setting its own geometry check rejects.
        hull() for (a = [CAM_ANGLE_MIN + SLOT_INSET, CAM_ANGLE_MAX - SLOT_INSET])
            translate([PAD_X + PAD_T - EPS,
                       PIV_WY + IDX_R*sin(90 - a),
                       PIV_WZ - IDX_R*cos(90 - a)])
                rotate([0,90,0]) cylinder(d = SLOT_W, h = PAD_T + 2*EPS);
    }
}

// ---- part 1: bottom plate + bosses ----
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
    }
}

// ---- part 2: top plate + arm ----
module mount_top() {
    union() {
        difference() {
            union() {
                translate([0,0,half]) _plate();
                // tongue for the arm to stand on, forward of the screw boss
                translate([PAD_X + PAD_T, y_front, half]) cube([PAD_T, ARM_TONGUE, PLATE_T]);
            }
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
        _arm();
    }
}

// ---- part 3: the cradle, its own part now ----
// Exported FLAT, in its own frame — print it on its back, no supports and no
// 60 deg fused overhang. The tilt is set at assembly by which index hole the
// second screw goes through.
module mount_cradle() {
    difference() {
        union() { _cradle(); _cradle_pad_solid(); _pad_foot(); }
        _cradle_pad_bores();
    }
}

// Assembly view only — never exported as a part.
module cradle_placed() {
    translate([0, PIV_WY, PIV_WZ]) rotate([TILT, 0, 0])
        translate([0, -CR_OY/2, -PIV_Z]) mount_cradle();
}
