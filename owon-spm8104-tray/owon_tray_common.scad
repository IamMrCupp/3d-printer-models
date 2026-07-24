// owon_tray_common.scad — shared dimensions for the OWON SPM8104 top tray.
//
// Measured on the actual unit (the datasheet's 82 mm width is WRONG):
//   lid width  84.30 mm  (calipers)
//   lid length ~226 mm   (flat all the way to the plastic front bezel)
//   height     142 mm    (spec)
//   venting    rear fan + side slots low on the case — skirts stay well above
//
// The 84.30 mm width is the happy accident that makes this work: a 2-cell
// Clickfinity plate is exactly 84.00 mm, so it sits flush with ~0.15 mm of case
// showing per side. 5 cells (210 mm) fits the length with ~16 mm to spare.

/* [Case] */
CASE_W   = 84.30;  // measured lid width
CASE_CLR = 0.40;   // total slip clearance so the clamp drops on

/* [Tray] */
GX = 2;            // cells across (84.00 mm — flush on the lid)
GY = 5;            // cells deep  (210 mm)
PLATE_H_ = 4.00;   // must match PLATE_H in lib/clickfinity.scad

/* [Clamp rail] */
SKIRT_T     = 2.50;  // skirt wall thickness
SKIRT_D     = 20.0;  // how far the skirt drops down the case side.
                     //   Keep SHORT — the side vents sit lower down the case.
// NOTE: the rail supports the plate from BELOW, it does not hook over it.
// A Gridfinity bin is 41.5 mm in a 42 mm cell — only 0.25 mm of plate rim per
// side. There is nothing to clamp over: any inward flange lands on top of the
// outer-row bins and stops them seating. So: a lip under the plate edge, and an
// upstand beside it.
LIP_IN   = 2.00;   // how far the lip reaches inward under the plate edge
LIP_T    = 1.50;   // lip thickness — the plate rides this far above the lid
RAIL_LEN    = GY*42; // rail runs the full plate length

/* [Clamp screws — M4 heat-set insert + M4 machine screw] */
// The boss takes a brass M4 heat-set insert (you have the M2–M6 kit); an M4
// machine screw threads through it and its tip presses the case. VERIFY HS_D
// against your actual inserts — install diameter varies by brand (a common M4
// heat-set wants ~5.6 mm; measure yours or check the insert datasheet).
HS_D       = 5.60;   // heat-set insert install hole diameter (M4) — VERIFY
HS_L       = 8.00;   // insert length (bore depth from the outer boss face)
BOSS_OD    = 10.0;   // boss outer diameter
BOSS_EXT   = 6.00;   // how far the boss stands off the outer skirt face
SCREW_Z    = -11.0;  // screw height on the skirt (below the lid line)
SCREW_Y    = 62.0;   // +/- screw position along the rail
// Use an M4 machine screw ~16–20 mm long. A stick-on rubber/felt dot on the tip
// keeps it from marring the case.

// Derived
PLATE_W  = GX*42;
PLATE_L  = GY*42;
SKIRT_IN = CASE_W/2 + CASE_CLR/2;   // inner face of the skirt
SKIRT_OUT= SKIRT_IN + SKIRT_T;
