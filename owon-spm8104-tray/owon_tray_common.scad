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

/* [Thumbscrews] */
THUMB_TAP  = 3.40;   // M4 self-tapping pilot in PETG
THUMB_BOSS = 8.00;   // boss OD on the outer skirt face
THUMB_EXT  = 4.00;   // boss length — more thread engagement
THUMB_Z    = -11.0;  // height on the skirt (below the lid line)
THUMB_Y    = 62.0;   // +/- position along the rail

// Derived
PLATE_W  = GX*42;
PLATE_L  = GY*42;
SKIRT_IN = CASE_W/2 + CASE_CLR/2;   // inner face of the skirt
SKIRT_OUT= SKIRT_IN + SKIRT_T;
