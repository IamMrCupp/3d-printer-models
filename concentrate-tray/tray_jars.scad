// tray_jars — drop-in tray for concentrate jars, two sizes in one pocket.
//
// NOT GRIDFINITY. It drops into a parametric 20×20×4 cm protective case, whose
// cavity measures 199.50 × 199.50 (rastered off `bottom-20x20x4cm.stl`, not the
// nominal 200). Deliberately standalone so it travels in the case.
//
// TWO SIZES, ONE POCKET. Each pocket is a ⌀45 recess with a ⌀35 bore nested
// below it. A wide jar sits on the shoulder; a slim jar drops through and is
// held by the lower bore.
//
// ⚠️ THE TWO SIZES DO NOT SIT AT THE SAME HEIGHT, and cannot. A slim jar landing
// in a bore below the wide jar's shoulder ends up lower by exactly that bore's
// depth. Both stand proud enough to pinch out:
//     wide  rests at RECESS deep      -> stands 14.3 proud
//     slim  rests at RECESS+BORE deep -> stands  6.3 proud
//
// FIVE ACROSS IS IMPOSSIBLE, AND IT IS THE DIAMETER, NOT THE LAYOUT. Five ⌀45.6
// pockets need 228 mm before any wall at all, against a 199.5 cavity. Four is the
// most that fits on either axis, so the counts available are 4×4 = 16, 4×3 = 12,
// and 3×3 = 9. 16 beats the 15 originally wanted, in a squarer block.
//
// PRINT: as emitted, floor down. No supports — every wall is vertical and every
// floor faces up.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp

/* [Jars — measured] */
WIDE_D  = 45.0;   // [20:0.1:80] ✅ widest jar
SLIM_D  = 35.0;   // [15:0.1:70] ✅ slim jar
JAR_H   = 26.3;   // [10:0.1:60] ✅ both jars are this tall
JAR_CLR = 0.6;    // [0:0.1:2] slip clearance on each bore

/* [Case] */
CAVITY  = 199.5;  // rastered from bottom-20x20x4cm.stl — NOT the nominal 200
CASE_CLR = 2.0;   // [0.5:0.5:6] total slack so the tray drops in and lifts out

/* [Layout] */
COLS = 4;  ROWS = 4;   // 16. ROWS=3 gives 12 and frees a strip of the case
WALL  = 3.0;      // [1.5:0.1:6] between pockets and at the edges
FLOOR = 3.0;      // [2:0.5:6]
CORNER = 8;       // [0:1:20] outer corner radius, to clear the case's corners

/* [Pocket depths] */
RECESS = 12.0;    // [6:0.5:20] wide jar sits on this shoulder
BORE   = 8.0;     // [4:0.5:20] slim jar drops this much further

$fn = 96;

WIDE = WIDE_D + JAR_CLR;
SLIM = SLIM_D + JAR_CLR;
OX = COLS*WIDE + (COLS+1)*WALL;
OY = ROWS*WIDE + (ROWS+1)*WALL;
H  = FLOOR + RECESS + BORE;

assert(SLIM < WIDE, "Slim bore must be narrower than the wide recess.");
assert(OX <= CAVITY - CASE_CLR, str("Tray is ", OX, " wide — will not fit the ", CAVITY, " cavity."));
assert(OY <= CAVITY - CASE_CLR, str("Tray is ", OY, " deep — will not fit the ", CAVITY, " cavity."));
assert(RECESS + BORE < JAR_H, "Pocket deeper than the jar — nothing to grab.");
echo(str("tray ", OX, " x ", OY, " x ", H, " in a ", CAVITY, " cavity; ",
         COLS, "x", ROWS, " = ", COLS*ROWS, " jars; wide stands ",
         JAR_H - RECESS, " proud, slim ", JAR_H - RECESS - BORE));

module _rr(w, d, r) { offset(r) offset(-r) square([w, d], center = true); }

difference() {
    linear_extrude(H) _rr(OX, OY, CORNER);
    for (cx = [0 : COLS-1], cy = [0 : ROWS-1]) {
        x = (cx - (COLS-1)/2) * (WIDE + WALL);
        y = (cy - (ROWS-1)/2) * (WIDE + WALL);
        // wide recess, upper
        translate([x, y, FLOOR + BORE])
            cylinder(d = WIDE, h = RECESS + 0.1);
        // slim bore, nested below it
        translate([x, y, FLOOR])
            cylinder(d = SLIM, h = BORE + 0.1);
    }
}
