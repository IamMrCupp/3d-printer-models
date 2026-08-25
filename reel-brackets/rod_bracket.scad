// rod_bracket — shelf-edge clamp carrying an 8 mm rod of tape or wire reels.
// Print TWO (three for a long span).
//
// HOW YOU USE IT:
//   Slide a bracket onto the shelf's front edge at each end. Thread the rod
//   through one, through the reels, into the other. Reels hang below the shelf
//   front; you pull tape straight down. To add a reel, slide the rod out sideways.
//
// WHY IT HOOKS RATHER THAN STICKS: the load self-tightens the grip. Weight on the
// rod tries to rotate the bracket about the shelf's front-bottom edge, which
// pulls the top arm DOWN onto the shelf face. An adhesive pad does the opposite —
// the same rotation peels its front edge, and peel is how pads fail. The hook
// needs no adhesive at all; add some under the top arm only if you want it
// permanent.
//
// WHY A PAIR: two ends means the rod length never has to be known. An 8 mm steel
// rod over 18" with ~600 g of reels sags 0.19 mm, so two is enough.
//
// NO BEARINGS, NO HUBS. Reels ride straight on the rod like a roll on a dowel —
// the 78.5 mm core just rests on the 8 mm rod and turns. The core rubbing the rod
// gives a little drag, which is wanted for wire (a free-spinning spool overruns
// and birdnests) and harmless for tape.
//
// PRINT: flat face on the bed. The bore then prints as a vertical hole with no
// bridge, and the layers run across the pull rather than along it. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp

/* [Shelf] */
SHELF_T   = 21.12;  // [6:0.1:40] ✅ MEASURED 2026-08-25. Was 12.7 (a 1/2" guess) —
                    //   the real shelf is 8.42 mm thicker, so that slot would not
                    //   have gone on at all.
SHELF_CLR = 0.8;    // [0.2:0.1:2] slot clearance, so it slides on
GRIP      = 45.0;   // [20:1:90] how far it reaches back onto the shelf

/* [Rod] */
ROD_D     = 8.0;    // [3:0.5:16] measured
ROD_CLR   = 0.6;    // [0.2:0.1:1.5] it must turn freely, not a bearing fit

/* [Reels] */
REEL_OD   = 92.0;   // [40:1:200] largest reel
CLEAR     = 8.0;    // [3:1:25] gap between reel edge and the shelf underside

/* [Bracket] */
WIDE      = 30.0;   // [15:1:60] bracket width along the shelf edge
ARM       = 5.0;    // [3:0.5:10] arm thickness above and below the shelf
BOSS      = 6.0;    // [4:0.5:10] material around the bore, all round

// Spine thickness is DERIVED from the bore, never set by hand. It was 7 mm
// against an 8.6 mm bore, so the hole cut straight out through both faces and
// left an open channel — a rod would have dropped out. Anything that has to
// contain a hole must be sized from that hole.
SPINE = ROD_D + ROD_CLR + 2*BOSS;

SLOT = SHELF_T + SHELF_CLR;
DROP = REEL_OD/2 + CLEAR;             // shelf underside to rod centre
BOT  = -SLOT - DROP - ROD_D/2 - BOSS; // lowest point

assert(SPINE >= ROD_D + ROD_CLR + 2*3, "Spine too thin to contain the bore.");
echo(str("slot ", SLOT, " for a ", SHELF_T, " shelf; spine ", SPINE,
         " around a ", ROD_D + ROD_CLR, " bore; rod ", DROP,
         " below the shelf; part ", WIDE, " x ", GRIP + SPINE, " x ", ARM - BOT));

difference() {
    union() {
        // top arm — lies on the shelf
        translate([-WIDE/2, 0, 0]) cube([WIDE, GRIP, ARM]);
        // bottom arm — under the shelf, the other jaw
        translate([-WIDE/2, 0, -SLOT - ARM]) cube([WIDE, GRIP, ARM]);
        // front spine — closes the C and carries the load down to the rod
        translate([-WIDE/2, -SPINE, BOT]) cube([WIDE, SPINE, ARM - BOT]);
        // gusset from the spine into the bottom jaw
        translate([-WIDE/2, 0, -SLOT - ARM]) rotate([90, 0, 90])
            linear_extrude(WIDE) polygon([[0, 0], [14, 0], [0, -14]]);
    }
    // rod bore, across the bracket, centred in the spine
    translate([-WIDE, -SPINE/2, -SLOT - DROP]) rotate([0, 90, 0])
        cylinder(d = ROD_D + ROD_CLR, h = 3*WIDE, $fn = 64);
}
