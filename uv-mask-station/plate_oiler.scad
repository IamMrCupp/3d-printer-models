// plate_oiler — 3×3 plate with a round recess for the oiler.
//
// IT LIVES WITH THE UV MASK STATION, NOT THE CLEANING BENCH. The oiler is a
// DISPENSING tool: it lays UV mask and solder paste down under the scope, which
// wastes far less than picking it up on tweezers. It belongs next to the masks
// and their colour trays, not with the swabs and sponges.
//
// Calipered 2026-09-07: the oiler is ⌀95.95 and the recess wants to be 5 mm deep.
//
// A RECESS, NOT A BIN. The oiler is only located, not contained — 5 mm of depth
// stops it sliding and nothing more. That is what was asked for, and it is the
// right call: a deep well would bury a round object you have to pick up
// one-handed, and a ⌀95.95 well would be most of a 3×3's volume in wall.
//
// 3×3 is the smallest grid that takes it. A ⌀95.95 circle does not fit a 2×2's
// 81.1 mm interior — not close. In a 3×3 it leaves 14.6 mm of rim all round.
//
// PRINT: as emitted, feet down. No supports — the recess is an open pocket.
include <../lib/gridfinity.scad>

NX = 3; NY = 3;

OILER_D  = 95.95;   // calipered
OILER_CLR = 0.40;   // it has to drop in and lift out, not be pressed in
RECESS_D = OILER_D + OILER_CLR;
RECESS   = 5;       // [2:0.5:15] depth, as specified
FLOOR    = 2.0;

H = BIN_BASE_H + FLOOR + RECESS;

EPS = 0.01;

assert(RECESS_D < NX*GF - 0.5 - 2*4, "Recess leaves less than 4 mm of rim — too fragile.");
echo(str("⌀", RECESS_D, " recess ", RECESS, " mm deep in a ", NX*GF-0.5,
         " mm plate; rim ", (NX*GF - 0.5 - RECESS_D)/2, " mm, total height ", H));

difference() {
    bin_blank(NX, NY, H);
    // Through the top face, never stopping on it.
    translate([0, 0, H - RECESS])
        cylinder(d = RECESS_D, h = RECESS + EPS, $fn = 192);
}
