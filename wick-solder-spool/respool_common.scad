// Respooler — a source-spool stand. Winds wick or wire onto the printed spool.
//
// THERE IS NO CRANK AND NO DRIVEN STATION, BECAUSE NEITHER IS NEEDED. The
// printed spool already spins in the wick holder's own brackets — that is what
// its 0.30 mm spigot and 0.40 mm journal clearances are for. Winding 15 m of
// 3 mm braid is only ~126–149 turns on a ⌀56 flange you can grip, so you turn it
// by hand and this stand just feeds it.
//
// That collapsed the whole jig. An earlier sketch had a crank, a driven upright
// and two flats milled on the spool's journal to drive it — a spool revision for
// a problem that does not exist.
//
// THE EXISTING HOLDER CANNOT HOST THE SOURCE SPOOLS. Both fail, for different
// reasons, which is why this stand exists at all:
//
//   solder braid   44.75 wide  vs the holder's 34.25 mm span   — too wide
//   micro wire     ⌀69.13      vs the holder's ⌀60 envelope    — too big
//
// All source-spool numbers are calipered (2026-09-07):
//
//   solder braid       ⌀48.50 x 44.75 wide, bore 10.25
//   micro wire #1/#2   ⌀69.13 x 13.50 wide, bore 11.30
include <../lib/gridfinity.scad>

NX = 2; NY = 2;          // 2x2 is 83.5 across — clears the ⌀69.13 spool
BASE_H    = 8;           // solid base under the post

POST_D    = 9.9;         // clears BOTH bores: 0.35 in the braid's 10.25,
                         //   1.40 in the wire's 11.30
POST_H    = 56;          // widest spool 44.75 + washer + loading clearance
POST_CHAM = 1.2;         // lead-in so a spool drops on without fishing for it
POST_SINK = 1.5;         // how far the post buries into the base — a PARTIAL
                         //   area join, so it overlaps rather than butting

WASHER_D  = 40;          // sits on the spool's top flange
WASHER_H  = 6;
WASHER_CLR = 0.4;        // free on the post, it must not bind

EPS = 0.01;

assert(NX*GF - 0.5 > 69.13, "Base is narrower than the largest source spool.");
assert(POST_D < 10.25, "Post must clear the tighter of the two spool bores.");
assert(POST_H > 44.75 + WASHER_H, "Post is too short for the widest spool plus its washer.");
echo(str("post ⌀", POST_D, " x ", POST_H, " above a ", NX*GF-0.5, " mm base"));
