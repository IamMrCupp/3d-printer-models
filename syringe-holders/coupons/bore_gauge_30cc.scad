// bore_gauge_30cc — the AMTECH 30 cc flux barrel, 25.5 mm.
//
// That reading is marked ⚠ in survey/MEASUREMENTS.md (taken off a rotated
// caliper display), so this coupon checks the barrel as much as the clearance.
// If none of the four accepts the syringe, the 25.5 is wrong — say so rather
// than widening the bin.
include <bore_gauge_common.scad>

BARREL = 25.50;
bore_gauge(BARREL, [0.4, 0.7, 1.0, 1.3]);
