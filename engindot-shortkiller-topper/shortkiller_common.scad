// shortkiller_common.scad — shared dimensions for the ENGINDOT topper: a
// Clickfinity plate on the supply's lid, and Gridfinity bins that drop into it.
//
// EVERYTHING HERE IS GRID-BASED. The Shortkiller lives in a bin, not in a
// bespoke cradle, so it can be moved to any other Clickfinity or Gridfinity
// plate on the bench. Bins are baseplate-agnostic (phase-2 decision #2): the
// Clickfinity latch grabs an unmodified Gridfinity bin foot.
//
// HOW IT ATTACHES — DROP-OVER FRAME, same as the OWON
// ---------------------------------------------------
// engindot_frame.scad wraps the top of the supply; the Clickfinity plate drops
// into its inner ledge and is bonded there. Bins click into the plate. Two
// parts because the plate must print latches-UP and the frame walls-DOWN —
// there is no single orientation that is right for both.
//
// The vent problem, and why it does not kill the frame: the ENGINDOT vents the
// FULL HEIGHT of both sides, unlike the OWON whose vents sit low (see
// owon_tray_common.scad:24). But the OWON frame is not held on by its skirts —
// the front/back LIPS hook the top edges and do the retention; the skirts only
// stop sideways slide. So here the skirts are SHORT (SKIRT_D, default 6 mm),
// covering a sliver of the intake instead of 20 mm of it, and the lips do the
// work. Set SKIRT_D lower, or the frame narrower, if that sliver still bothers
// you — the frame stays on either way.
//
// THE BIN IS OPEN AT BOTH ENDS
// ----------------------------
// The Shortkiller is operated in place. Its FRONT carries the A/V displays,
// the V+/V- buttons and the GX12 output connector; its REAR carries the DC
// input jack and the power rocker. So the bin's front wall is removed outright
// and the rear is cut down to a low backstop.
//
// Because both ends are open, the box may be LONGER than its bin and simply
// overhang — the bin grips the middle. That is why NY_CRADLE is not a fit.
//
// WHAT IS AND ISN'T MEASURED
// --------------------------
// SK_W = 98  — read off a tape photo, CONFIRMED by printing bin_shortkiller_testfit
// SK_D = 171 — read off a tape photo. Not a fit: both ends are open.
// SK_H = 55  — still an estimate. Only matters if the wrap frame happens;
//              wrap_test_bands.scad settles it.
// ENGINDOT lid = 80 x 193 — MEASURED by the user. Every earlier figure here
//              (102x216, then 84) was mine, off tape photos, and wrong. The lid
//              is NARROWER than the 84 mm plate and SHORTER than a 5-cell one,
//              which is why GY is 4 and the frame's top flares past its skirt.
//              Full list with confidence marks: survey/MEASUREMENTS.md.

include <../lib/gridfinity.scad>

/* [Shortkiller body] */
SK_W =  98.0;  // [90:0.5:130] read off a tape photo as ~3.85in. +/-3 mm is
               //   absorbed by the flexures; beyond that, use the fit gauge.
SK_D = 171.0;  // [120:1:220] read off the tape photo at just under 7in. Not a
               //   fit anyway — both ends are open, so the box overhangs the
               //   167.5 mm bin by a few mm and that is fine.
SK_H =  55.0;  // [35:0.5:80]  ⚠️ ESTIMATE — cosmetic, informs BIN_H only

/* [Grid] */
// GX x GY = 2 x 5 = 84 x 210 mm. The plate is deliberately kept NARROWER than
// the lid (measured 102 mm) so it hugs the supply the way
// owon-spm8104-tray does, rather than overhanging it. The Shortkiller is wider
// than 84 mm, so the BIN overhangs the grid instead of the plate overhanging
// the supply — see the Overhang body section below. GY is the one still-unread
// number: the lid measured ~216 mm front to back, so 210 fits with ~6 mm spare.
GX = 2;  // [2:1:5] plate cells across — 84 mm, hugs the lid like the OWON
GY = 5;  // [3:1:7] plate cells deep — 210 mm, deliberately LONGER than
         //   the 193 mm lid so a rear cell survives for the probe bucket.
         //   The plate overhangs the frame ~8.5 mm at each end.

NX_CRADLE = 2;  // [2:1:5] Shortkiller bin, across — must clear SK_W
NY_CRADLE = 4;  // [2:1:6] Shortkiller bin, deep — box may overhang this
NX_LEADS  = 1;  // [1:1:5] probe/leads bin, across — 1x1, see below
NY_LEADS  = 1;  // [1:1:3] probe/leads bin, deep

/* [Bin heights] */
BIN_H       = 42.0;  // [21:7:63] cradle bin height (6 x 7 mm units). Taller than
                     //   a 5u bin because the flare has to finish under the floor.
LEADS_BIN_H = 42.0;  // [21:7:63] matches the cradle bin, and the extra depth is
                     //   what makes the probe tube stable — see below.
FLOOR_T     = 2.4;   // [1.4:0.2:4] bin floor over the Gridfinity base

/* [Probe + leads bin] */
// One bucket: the probe stands in a tube rising from the bin floor, the
// alligator lead drapes into the well around it. Leads stay plugged into the
// Shortkiller's GX12 connector and loop over to here.
//
// This bin sits BEHIND the Shortkiller (rear cell of the plate). That puts a
// 42 mm wall right up against the box's REAR panel — the one carrying the DC
// jack and the power rocker. So the wall on that side is cut down to
// LEADS_FACE_H, low enough to still corral a lead but not to shadow the panel.
//
// TIP-DOWN, deliberately. The tube is blind, so the sharp end is buried in
// plastic and you grab the handle — same reasoning as the UV lamp holster in
// phase-2 (B.5). Tip-up would put a needle at eye level and make you grab it
// by the business end.
//
// 1x1, not 2x1. The rear row of the plate is two cells wide, and the
// Shortkiller's DC power cord is NOT detachable — it has to leave the back of
// the tray somewhere. So one rear cell is this bucket and the other stays
// EMPTY as the cord's route. Do not fill it.
//
// ⚠️ Accepted tradeoff: a ~150 mm probe standing in a 42 mm footprint is a real
// tipping moment on the latch tongues. The alligator lead coiling in beside it
// adds ballast low down, which helps. If it proves tippy in use the fix is a
// shorter tube stick-out, not a taller bin.
PROBE_D      = 13.0;  // [6:0.5:25] ⚠️ ESTIMATE — probe body diameter.
PROBE_CLR    =  1.0;  // [0.2:0.1:3] bore clearance. Generous on purpose: this
                      //   is a holster, not a grip. Too loose is harmless.
PROBE_WALL   =  2.8;  // [1.6:0.2:5] tube wall thickness
PROBE_OFFSET =  8.0;  // [0:0.5:12] tube centre from the bin centre, along +Y —
                      //   i.e. pushed to the BACK, so the crescent of free well
                      //   left over sits at the front by the cut-down wall,
                      //   where you actually drop the lead in.
LEADS_WALL   =  1.6;  // [1.2:0.2:3] bin wall thickness
LEADS_FACE_H = 13.0;  // [0:0.5:35] height of the wall FACING the Shortkiller,
                      //   measured from the bin floor. Keep low — it is the
                      //   only thing between this bin and the rear panel.

/* [Overhang body] */
// The FOOT is NX_CRADLE cells (84 mm) so it clicks into a plate that hugs the
// supply. The BODY above it flares out to clear a box wider than the grid.
//
// Two rules make this printable and sound:
//   * the flare is a 45-degree ramp (CHAMF == overhang per side), never a step
//   * the ramp must finish BELOW the pocket floor, or the pocket would cut the
//     side walls away at the height where they are still narrow
// That second rule is what forces BIN_H to 6 units instead of 5.
BODY_WALL = 6.0;   // [3:0.5:10] side-wall thickness of the flared body

/* [Grip] */
// The bin's side walls are FLEXURES. Each is relieved on its OUTER face so a
// thin skin is left facing the pocket, carrying a bump that presses on the case
// side. The pocket is modelled oversize and the bumps take up the slack, so
// anything within ~+/-3 mm of the real SK_W still grips.
POCKET_SLOP  = 3.0;   // [0:0.5:6]   pocket width over SK_W
BUMP_REACH   = 2.2;   // [1:0.1:4]   how far each bump stands into the pocket
BUMP_H       = 9.0;   // [4:0.5:16]  bump vertical extent
FLEX_T       = 2.0;   // [1.2:0.1:3] flexure skin (grip ~ t^3 — keep thin)
FLEX_START   = 4.0;   // [2:0.5:10]  how far above the bin floor the relief begins
RELIEF_INSET = 10.0;  // [6:1:20]    relief inset from each bin end, so the
                      //   rounded outer corners stay solid

/* [End lips] */
// A LOW lip at BOTH ends so the box cannot slide out either way.
//
// This is what forces the body to be longer than its foot. The box is 171 mm;
// a 4-cell foot is 167.5 mm, so with two lips there is nothing left to sit in.
// The body therefore extends FRONT_EXT past the foot on a 45-degree ramp —
// the same overhang trick used for the width, rotated 90 degrees.
//
// FORWARD ONLY. A rear extension would collide with the probe bucket in the
// next cell. The front has nothing to hit: the bin already overhangs the plate
// edge there.
//
// ⚠️ Both lips must stay LOW. The rear one clears the DC jack and rocker, which
// sit high on that face. The FRONT one has to clear the GX12 connector and the
// V+/V- buttons, and it is the more dangerous of the two — check it against the
// real box before committing to a 5-hour print.
LIP_T       = 3.5;  // [2:0.5:6]   thickness of each end lip
END_CLR     = 2.0;  // [0:0.5:6]   total fore-aft slop for the box
BACKSTOP_H  = 9.0;  // [0:0.5:20]  rear lip height above the pocket floor
FRONT_LIP_H = 9.0;  // [0:0.5:20]  front lip height. 0 leaves the front open.
BACKSTOP_T  = LIP_T;

/* [Drop-over frame] */
// Cross-section of one side jaw, from the middle out: a ledge that carries the
// plate edge, an upstand beside it, then the short skirt down the case side.
// Front/back end-bars tie the two jaws together and carry the hooking lips.
CASE_L    = 196.85; // [120:1:280] MEASURED lid length = 7 3/4". This is the CASE,
                    //   not the frame. MOUNT_L is derived from it — see below.
CASE_W    =  80.0;  // [70:0.5:140] MEASURED via frame_fit_gauge: the 86 collar
                    //   showed ~1 mm of gap per side. Within a hair of the OWON's
                    //   MEASURED BY THE USER at 80. (Gauge collars first put it
                    //   under 86; an even earlier 102 was a tape-photo misread that
                    //   produced a frame falling straight over the case.) 80 is
                    //   NARROWER than the 84 mm plate — see TOP_WALL below.
CASE_CLR  =   0.8;  // [0.3:0.1:3]  slip clearance on the CASE only. The plate no
                    //   longer depends on it — at 80 the case is narrower than the
                    //   plate, so the pocket sits outboard of the skirt entirely.
TOP_WALL  =   2.5;  // [2:0.5:5]    wall outboard of the plate pocket. The frame's
                    //   upper half is WIDER than its skirt: it must grip an 80 mm
                    //   case below and carry an 84 mm plate above. Same overlap
                    //   the bin uses, rotated onto the frame.
// RAMP is DERIVED, not set — see the bottom of this file. It is exactly the
// step between pocket wall and skirt wall, giving a 45-degree transition.
SKIRT_CLR =   0.0;  // [0:0.1:2]    WIDTH slip only. Separate from CASE_CLR, which
                    //   sets the LENGTH span — that one measured perfect on the
                    //   gauge and must not move. At +0.8 the width gauge showed
                    //   ~1 mm of slop, so the skirt span is now the measured case
                    //   width exactly; print tolerance supplies the fit.
SKIRT_T   =   2.5;  // [1.5:0.5:5]  skirt wall thickness
SKIRT_D   =   7.0;  // [1:0.5:25]   ⚠️ how far the skirt drops down the case SIDE.
                    //   The sides are ALL vent, so this covers intake. Keep it
                    //   short — it only resists sideways slide; the end lips do
                    //   the real retention.
LEDGE_IN  =   2.0;  // [1:0.5:5]    how far the ledge reaches under the plate edge
PLATE_CLR =   0.6;  // [0:0.1:2]    ⚠️ slip clearance around the plate. The OWON
                    //   frame has none of its own — its upstands sit at the CASE
                    //   half-width, which happens to be wider than its plate. Put
                    //   them on the PLATE half-width, as here, and zero clearance
                    //   means the plate will not go in. Do not set this to 0.
LEDGE_T   =   3.0;  // [1.5:0.5:6]  ledge thickness. Thicker than the OWON's
                    //   because the plate (84) is much narrower than the case
                    //   (102), so this shelf spans ~9 mm instead of ~0.
END_BAR_T =   5.0;  // [2:0.5:10]   end-bar thickness front-to-back
END_SHELF = true;   // support the plate's overhang past each end of the frame.
                    //   The plate is LONGER than the lid, so its last ~8.5 mm at
                    //   each end cantilever into free air with a bin sitting on
                    //   them — a shim underneath has nothing to rest on. This
                    //   carries it on a shelf off the end bar, with a 45-degree
                    //   gusset so it still prints walls-down. Reach is capped at
                    //   END_LIP_D to hold that gusset at 45 degrees.
END_LIP_D =   7.0;  // [3:0.5:14]   how far the front/back lip drops over the edge.
                    //   ⚠️ MUST EQUAL SKIRT_D. The frame prints WALLS DOWN, so the
                    //   skirt bottoms and the end-lip bottoms are both bed contact.
                    //   If they differ, whichever is shorter starts in mid-air.
// ⚠️ MOUNT_L MUST EXCEED PLATE_L_ + 2*END_BAR_T. Not for fit — for PRINTABILITY.
//
// The frame prints WALLS UP, standing on the tops of its two skirt walls. The
// end bars have to reach that same plane or they hang in mid-air, and each one
// then bridges ~85 mm between the side walls. A previous revision topped them at
// ledge height so the plate could rest OVER them; it printed with the end bars
// sagging into the void. They must run FULL HEIGHT, which means the plate has to
// fit BETWEEN them, which means this inequality.
//
// Beyond that the value is forgiving. At CASE_W 84 the side skirts grip a case
// the same width as the OWON's, so THEY locate the frame and the end lips are a
// bonus. Short of the lid edges it rests on the lid; past them it sits slightly
// proud. Neither loses retention, which is why the lid depth — never reliably
// measured — does not gate a print.

/* [General] */
EPS = 0.01;
// ⚠️ DO NOT CHANGE THIS CASUALLY. lib/gridfinity.scad's _bin_cell offset() chain
// emits non-manifold edges at some ($fn, bin-width) combinations. Which ones is
// neither intuitive nor monotonic — higher is NOT safer. Measured on this repo:
//     1-wide: 16,24,40,56 clean | 32,48,64,128 BAD
//     2-wide: 32,40,48,56,128 clean | 64,72,80,96 BAD
//     3-wide: 16,24,32,64 clean | 48 BAD
// This model builds 1-wide and 2-wide bins, so it needs a value clean in BOTH
// of the first two rows. 40 and 56 qualify; 40 is used. Note 32 — the obvious
// pick from the 2- and 3-wide rows alone — is BAD for 1-wide.
// Re-run the sweep before changing it. Tracked as a lib bug.
$fn = 40;

// Derived — do not edit
POCKET_W  = SK_W + POCKET_SLOP;
FOOT_W    = NX_CRADLE * GF - 0.5;          // 83.5 — what clicks into the plate
BODY_W    = POCKET_W + 2 * BODY_WALL;      // wider than the grid, on purpose
OVERHANG  = (BODY_W - FOOT_W) / 2;         // how far each side hangs past the foot
CHAMF     = OVERHANG;                      // 45-degree ramp — printable, no support
FLOOR_Z   = BIN_BASE_H + CHAMF + FLOOR_T;  // pocket floor sits ABOVE the ramp
CRADLE_D  = NY_CRADLE * GF - 0.5;
SIDE_WALL = BODY_WALL;

// Frame — derived
PLATE_W_  = GX * GF;                 // 84  — plate footprint the ledge carries
PLATE_L_  = GY * GF;                 // 210
PLATE_T_  = 4.00;                    // must match PLATE_H in lib/clickfinity.scad
SKIRT_IN  = CASE_W / 2 + SKIRT_CLR / 2;
SKIRT_OUT = SKIRT_IN + SKIRT_T;
POCKET_HW = PLATE_W_ / 2 + PLATE_CLR / 2;   // plate pocket, independent of the case
TOP_OUT   = POCKET_HW + TOP_WALL;           // frame's outer half-width up top
MOUNT_L    = CASE_L + 2 * END_BAR_T + CASE_CLR;  // clear span = CASE_L + CASE_CLR
RAMP       = POCKET_HW - SKIRT_IN;               // 45-degree step, pocket to skirt
OVERHANG_Y = max(0, (PLATE_L_ - MOUNT_L) / 2);   // plate cantilever past each end
SHELF_OUT  = min(OVERHANG_Y, END_LIP_D);         // 45-degree gusset limit

// The end bars CARRY the plate rather than enclosing it: their top sits at
// ledge height so the plate rests over them. Enclosing would need
// MOUNT_L >= PLATE_L_ + 2*END_BAR_T = 220, and the lid is only ~216 — the frame
// would hang off the supply and the lips would grip nothing.
// NOTE: there is deliberately NO "MOUNT_L >= PLATE_L_" rule any more. The plate
// is longer than the frame and rests ON the end bars, overhanging both ends.
// The bridging that rule used to guard against is now handled by printing
// walls-down instead — see the END_LIP_D == SKIRT_D assert below.
assert(MOUNT_L - 2 * END_BAR_T >= CASE_L,
       "clear span between the end lips is shorter than the case — will not go on");
assert(POCKET_HW * 2 > PLATE_W_,
       "plate pocket has no clearance — raise PLATE_CLR");
assert(TOP_OUT > SKIRT_OUT,
       "upper block narrower than the skirt — skirt would overhang unsupported");
assert(END_LIP_D == SKIRT_D,
       "END_LIP_D must equal SKIRT_D — walls-down, both are bed contact");

// Body must be long enough for the box PLUS both lips. Whatever the foot does
// not provide is added at the front as a ramped extension.
BODY_D_REQ = SK_D + END_CLR + 2 * LIP_T;
FRONT_EXT  = max(0, BODY_D_REQ - CRADLE_D);

// Sanity: the pocket must have somewhere to live above the ramp.
assert(BIN_H > FLOOR_Z + 12,
       "BIN_H too short for this overhang — raise BIN_H or cut BODY_WALL/SK_W");

// The front ramp rises 1:1, so it must finish below the pocket floor just like
// the side flare does. If this trips, add a cell to NY_CRADLE.
assert(FRONT_EXT <= CHAMF,
       "FRONT_EXT exceeds the ramp height — NY_CRADLE too small for SK_D + lips");
