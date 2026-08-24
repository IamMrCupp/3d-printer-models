// plate_heat_gun — 2×2 Gridfinity plate that the heat gun's magnetic bracket
// screws down onto.
//
// HOW YOU USE IT:
//   The plate latches into the desk grid. The magnetic bracket sits on top and
//   four screws go down through it into the bosses below. The gun then parks on
//   the bracket's magnet as usual, and the whole assembly comes off the grid as
//   one piece if you ever move it.
//
// WHY 2×2 AND NOT 2×1. The hole pattern is only 36 × 21, which a 2×1 would take.
// But Clickfinity holds about 12.2 N per cell: a 2×1 is ~24 N (2.5 kgf) and a 2×2
// is ~49 N (5 kgf). Pulling a heat gun off a magnetic bracket beats 2.5 kgf
// easily, and then the plate lifts with the gun. Four cells, not two.
//
// ⚠️ SCREW SIZE IS ASSUMED, NOT MEASURED. SCREW_D is set for M3 self-tapping into
// plastic — the hole is deliberately undersized so the thread cuts its own way.
// Get it wrong and it either strips or splits the boss. Change SCREW_D before
// printing if these are M4 or a wood-type screw.
//
// PRINT: as emitted, feet down. No supports — the blind holes are vertical.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../lib/gridfinity.scad>

/* [Bracket] */
HOLE_X  = 36.0;   // measured 2026-08-20, centre to centre — a true rectangle
HOLE_Y  = 21.0;   // measured, centre to centre

/* [Screws] */
// Store the MEASURED screw, derive the hole. A self-tapper cuts its own thread,
// so the pilot is deliberately smaller than the screw — around 75-80% of the
// thread OD in PETG. Too big and it strips, too small and it splits the boss.
// An earlier version had the pilot at 2.5 against a 2.84 screw: 88% of OD, which
// would have stripped.
SCREW_OD  = 2.84;   // measured 2026-08-20 — thread outside diameter
PILOT_PCT = 0.78;   // [0.70:0.01:0.85] of OD
SCREW_D   = SCREW_OD * PILOT_PCT;
SCREW_L = 10.0;   // [6:1:20] how deep the hole goes — set the plate thickness first

/* [Plate] */
DECK    = 12.0;   // [8:0.5:25] solid material above the foot. Must exceed SCREW_L
                  //   so the screw never breaks through into the baseplate socket.

H = BIN_BASE_H + DECK;

assert(DECK > SCREW_L + 1.5, "Screw would break through the underside of the deck.");
assert(HOLE_X + 3*SCREW_D < 2*GF - 0.5, "Hole pattern too wide for a 2x2.");
echo(str("plate ", 2*GF - 0.5, " square x ", H, " tall; ", SCREW_OD,
         " screw -> ", SCREW_D, " pilot, ", SCREW_L, " deep; holes at +/-",
         HOLE_X/2, ", +/-", HOLE_Y/2));

difference() {
    bin_blank(2, 2, H);
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx*HOLE_X/2, sy*HOLE_Y/2, H - SCREW_L])
            cylinder(d = SCREW_D, h = SCREW_L + 0.1, $fn = 32);
}
