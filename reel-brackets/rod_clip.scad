// rod_clip — snap-on C-clip that stops the rod walking out of the brackets.
// Print FOUR (two per rod: one outboard of each bracket).
//
// THE PROBLEM IT SOLVES: `rod_bracket`'s bore is a plain through-hole, so the rod
// is free to slide ALONG its own axis until it clears one bracket. Nothing in the
// bracket ever stopped that.
//
// WHY A CLIP ON THE ROD RATHER THAN A CHANGE TO THE BRACKET: the brackets are
// already printed and on the shelf. Anything that needs a feature on them means
// reprinting two 71 g parts to fix a 1 g problem.
//
// HOW YOU USE IT:
//   Push one onto the rod just OUTBOARD of each bracket, snapped up against the
//   bracket's outer face. The rod can then only travel until a clip hits a
//   bracket, which is nowhere. To pull a reel off, pop one clip and slide the rod.
//
// ⚠️ THE GRIP IS A PRINTED FIT AND HAS NOT BEEN CALIBRATED. `CLIP_ID` is 8.0
// against an 8.0 rod, which relies on holes printing slightly undersize to give
// the interference. If it slides on too loosely, drop it: `-D CLIP_ID=7.8`. If it
// will not go on, raise it. That is one 1 g reprint, not a gauge.
//
// PRINT: flat, as emitted. The C then flexes IN the layer plane when you snap it
// on, rather than trying to peel layers apart. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp

/* [Rod] */
ROD_D   = 8.0;    // [3:0.5:16] matches rod_bracket

/* [Clip] */
CLIP_ID    = 8.0;   // [6:0.1:16] bore. Nominal on purpose — see the note above
CLIP_WALL  = 2.5;   // [1.5:0.1:5] ring thickness
CLIP_W     = 6.0;   // [3:0.5:12] width along the rod
MOUTH      = 5.6;   // [3:0.2:10] opening. MUST be under CLIP_ID or it will not
                    //   stay on: the clip has to spring over the rod's widest
                    //   point and close again behind it
EAR        = 4.0;   // [0:0.5:8] finger tabs either side of the mouth, to pop it
                    //   off without a tool. 0 removes them
$fn = 96;

OD = CLIP_ID + 2*CLIP_WALL;

assert(MOUTH < CLIP_ID, "Mouth must be narrower than the bore or the clip falls off.");
assert(CLIP_WALL >= 1.5, "Ring too thin to spring without snapping.");
echo(str("clip ", OD, " od x ", CLIP_W, " wide, bore ", CLIP_ID,
         ", mouth ", MOUTH, " -> springs ", CLIP_ID - MOUTH, " mm to go on"));

linear_extrude(CLIP_W) {
    difference() {
        union() {
            circle(d = OD);
            // finger ears, so it can be popped off by hand
            if (EAR > 0)
                for (s = [-1, 1])
                    translate([OD/2 - 1, s*(MOUTH/2 + CLIP_WALL/2)])
                        square([EAR, CLIP_WALL], center = true);
        }
        circle(d = CLIP_ID);
        // the mouth, opening to +X
        translate([0, -MOUTH/2]) square([OD/2 + EAR + 1, MOUTH]);
    }
}
