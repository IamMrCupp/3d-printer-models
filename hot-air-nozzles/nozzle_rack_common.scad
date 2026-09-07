// Hot air nozzle rack — a 6×1 strip of posts for the rework wand's nozzles.
//
// NOZZLES SIT TIP-UP, COLLAR DOWN OVER A POST. Confirmed with the user
// 2026-09-07. The nozzles are split band clamps: a ⌀22.69 band that squeezes the
// wand, with two folded ears, a screw and a nut projecting on ONE side.
//
// Only the BAND is common to all ten. The tip sections below it are different
// lengths and some are offset, so nothing here may depend on tip geometry —
// inverted, the tips stand in free air above the rack where they foul nothing.
// Tip-down would drive them into the base and the bent ones would not seat.
//
// Calipered 2026-09-07:
//
//   band ID          22.69      the post is sized to this
//   band OD          23.95
//   across the nut   27.11      the ears stand 3.16 mm proud on one side
//   band section     ~23 mm     the common part; the post engages here
//   count            10
//
// ⚠️ POINT THE EARS ACROSS THE ROW, front or back. This is not decoration — it
// is what makes nine fit:
//
//   ears across the row   pitch on the 23.95 band   -> 9 posts on a 6×1
//   ears along the row    pitch on the 27.11 nut    -> 8 posts, and two adjacent
//                                                      nozzles turned inward
//                                                      collide (30.27 > 26.95)
//
// Nine is enough for ten nozzles because one is on the wand.
//
// A 1-deep row is 39.1 mm interior and the 27.11 envelope crosses it with 12 mm
// to spare, so pointing the ears across costs nothing at all.
include <../lib/gridfinity.scad>

NX = 6; NY = 1;          // 251.5 mm — the longest single strip the 270 bed takes
// 6 is as thin as this goes: the grid foot alone is BIN_BASE_H 4.75, leaving a
// 1.25 mm slab above it. Shelling the base gains NOTHING here — at this height
// the foot plus any sane floor already exceeds it, so there is no cavity. The
// ~145 g is the 6x1 grid foot itself, not slab that could be removed.
BASE_H    = 6;

BAND_ID   = 22.69;
BAND_OD   = 23.95;
POST_CLR  = 0.40;
POST_D    = BAND_ID - POST_CLR;     // 22.29
POST_H    = 18;                     // into a ~23 mm band, leaving 5 mm
POST_CHAM = 1.2;                    // lead-in, so a nozzle drops on
POST_SINK = 1.0;                    // partial-area join -> overlap, never butt.
                                    //   Kept under the 1.25 mm slab so the post
                                    //   does not reach into the foot profile.

GAP   = 3.0;
PITCH = BAND_OD + GAP;              // 26.95
IW    = NX*GF - 0.5 - 2*1.2;
COUNT = floor((IW + GAP) / PITCH);

EPS = 0.01;

assert(NX*GF - 0.5 <= 270, "Strip is longer than the 270 mm bed.");
assert(POST_D < BAND_ID, "Post must clear the band bore.");
assert(NY*GF - 0.5 - 2*1.2 > 27.11, "Row is too shallow for the nut envelope across it.");
echo(str(COUNT, " posts at ", PITCH, " mm pitch, spanning ",
         (COUNT-1)*PITCH, " mm of a ", IW, " mm interior"));
