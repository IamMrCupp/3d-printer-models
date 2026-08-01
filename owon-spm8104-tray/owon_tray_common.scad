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

// Rails run the full front-to-back length of the case TOP (~9", measured ≈225 mm
// rear edge → front bezel), NOT just the 210 mm plate — so the shallow end-lips
// below can reach the actual front/back edges. A little slide is fine, so a hair
// long is intentional; drop MOUNT_L if it binds.
MOUNT_L  = 228.0;  // [200:1:240] rail length front-to-back (~9")
RAIL_LEN = MOUNT_L;

/* [Front/back end-bars] */
// The two side jaws are TIED TOGETHER by a bar across each end — this is what
// makes the screw clamp work at all: the bar carries the screw reaction from one
// jaw to the other (closed loop). Without it, a side screw just shoves its own
// jaw off the case. Each bar also carries a SHALLOW downturn lip that hooks the
// front/back top edge (short, so it clears the front display / rear fan).
END_BAR_T = 5.00;  // [3:0.5:10] end-bar thickness along the length (rigidity)
END_LIP_D = 5.00;  // [3:0.5:12] how far the front/back lip drops over the edge

// (No clamp hardware — this is a passive drop-over frame. Side walls hug the
// case, front/back lips stop the slide, gravity holds it down.)

// Derived
PLATE_W  = GX*42;
PLATE_L  = GY*42;
SKIRT_IN = CASE_W/2 + CASE_CLR/2;   // inner face of the skirt
SKIRT_OUT= SKIRT_IN + SKIRT_T;
