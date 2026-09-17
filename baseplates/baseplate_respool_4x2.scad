// baseplate_respool_4x2 — 4×2 Clickfinity baseplate (168×84 mm) for the wick
// respooler: respool_stand (2×2, the source spool) and respool_winder (2×2, the
// spool being wound) side by side on one plate, so the pair can be carried off
// the bench and used anywhere. The click latches matter here — cranking and wire
// tension both try to lift the two plates, and the latches hold them down.
//
// No JOIN pockets: this plate travels on its own and never butts against another.
include <../lib/clickfinity.scad>
JOIN = false;
clickfinity_baseplate(4, 2, arms = true);
