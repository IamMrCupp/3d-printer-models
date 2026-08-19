// bore_gauge_10ml — PRINT THIS BEFORE bin_flux OR bin_uv_mask.
//
// 10 ml syringe barrel, measured 18.80 mm. Five collars spanning clearance
// 0.4 → 1.6 mm (bores 19.2 → 20.4). Push a syringe into each: the smallest one
// it enters without forcing is your clearance. Set CLR in lib/vessel.scad
// (or pass clr= per model) and only then print the bins.
//
// If it binds in ALL of them the barrel measurement is wrong, not the
// clearance — re-measure before widening anything.
include <bore_gauge_common.scad>

BARREL = 18.80;
bore_gauge(BARREL, [0.4, 0.7, 1.0, 1.3, 1.6]);
