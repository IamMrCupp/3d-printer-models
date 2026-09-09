// baseplate_consumables_4x4 — 4×4 Clickfinity baseplate (168×168 mm) for
// syringes/UV/rotary. Click-latch bin retention + edge dovetails (JOIN) so it can
// be joined to more plates and expanded later.
include <../lib/clickfinity.scad>
JOIN = true;
clickfinity_baseplate(4, 4, arms = true);
