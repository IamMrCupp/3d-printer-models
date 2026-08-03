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
CASE_CLR = 0.40;   // total slip clearance across the WIDTH. Confirmed on the
                   //   printed part — the width fit is fine, leave it alone.
CASE_L   = 226.00; // measured lid LENGTH, rear edge -> front bezel. THE frame
                   //   must clear this between its end lips. CONFIRM BY HAND
                   //   before printing — see the note on RAIL_LEN below.
CASE_L_CLR = 1.50; // total slip clearance along the LENGTH. Generous on purpose:
                   //   a little front-to-back slide is fine, seizing is not.

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

// RAIL_LEN is DERIVED (see bottom) — do not hand-set it.
//
// v1.0.3 shipped MOUNT_L = 228 as the frame's OUTER length, sized against the
// ~9" case. That was the wrong end of the part: the two end-bars eat END_BAR_T
// each, so the CLEAR SPAN the case actually has to fit into was only
// 228 - 2*5 = 218 mm, against a 226 mm case. The end lips came down flat on the
// case top ~4 mm in from each end and the frame perched instead of dropping over.
//
// The clear span is now driven by CASE_L, and the end-bars are added OUTSIDE it,
// so the lips land past the case edges by construction.

/* [Front/back end-bars] */
// The two side jaws are TIED TOGETHER by a bar across each end — this is what
// makes the screw clamp work at all: the bar carries the screw reaction from one
// jaw to the other (closed loop). Without it, a side screw just shoves its own
// jaw off the case. Each bar also carries a SHALLOW downturn lip that hooks the
// front/back top edge (short, so it clears the front display / rear fan).
END_BAR_T = 5.00;  // [3:0.5:10] end-bar thickness along the length (rigidity)
END_LIP_D = 5.00;  // [3:0.5:12] how far the front/back lip drops over the edge

// (No clamp hardware — this is a passive drop-over frame. Side walls hug the
// case, front/back lips stop the slide, gravity holds it down. The plate is
// permanent — you swap BINS, not the plate — so it's simply bonded into the
// frame at assembly. No retention mechanism needed.)

// Derived
PLATE_W  = GX*42;
PLATE_L  = GY*42;
SKIRT_IN = CASE_W/2 + CASE_CLR/2;   // inner face of the skirt
SKIRT_OUT= SKIRT_IN + SKIRT_T;

INNER_L  = CASE_L + CASE_L_CLR;     // clear span between the end lips
RAIL_LEN = INNER_L + 2*END_BAR_T;   // overall frame length
MOUNT_L  = RAIL_LEN;                // back-compat alias; RAIL_LEN is the truth
