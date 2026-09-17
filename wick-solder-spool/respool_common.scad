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
// The winder's fence and the crank are cut to the SPOOL, so they read the spool's
// own numbers rather than keeping copies. spool_common has no top-level geometry.
include <spool_common.scad>

NX = 2; NY = 2;          // 2x2 is 83.5 across — clears the ⌀69.13 spool
BASE_H    = 8;           // solid base under the post

SPIGOT_BORE = 9.70;      // the printed spool's spigot — see spool_common
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

// ---- winding station + crank ----------------------------------------------
// The spool cannot be cranked while it sits in the wick holder: installed, its
// journal top is flush with the bracket (41.40 vs 41.50) and there is nothing to
// grip. Out of the holder the whole 5.5 mm journal is exposed, so it winds here
// instead and goes back to the holder to live.
//
// The winder is its own 2x2 rather than a second station on the source stand:
// a ⌀69.13 source spool and a ⌀56 printed spool cannot both live on one 2x2, and
// two small plates place more freely on a bench than one long one.
WIND_SOCK_D = SPIGOT_BORE + 0.30;   // the spool's ⌀9.70 spigot drops in
WIND_SOCK_H = 4.0;
WIND_NX = 2; WIND_NY = 2;
assert(SPIGOT_BORE == SPIGOT_D, "respool's copy of the spigot has drifted from spool_common.");

// THE FIRST WINDER LET THE SPOOL JUMP OUT. It stood on a ⌀9.70 spigot 3.8 mm
// long in a 4 mm socket, with nothing holding it down. The wire pulls sideways
// about 20 mm up the hub; the only thing resisting that tip was a 30 g spool's
// own weight on a 28 mm flange — roughly 40 gf of wire tension turns it over,
// and the drag washer alone asks for more than that. Every time it tipped, the
// spigot cleared its socket and the wind sprang loose.
//
// So the plate now HOLDS THE LOWER FLANGE DOWN. A U-shaped fence wraps the
// flange: a half-round at the closed end, two short straight rails at the open
// end, and a lip leaning in over the flange's rim the whole way round. The
// socket becomes a slot out to the open edge. Slide the spool in along the
// slot, flange under the lip, until the spigot seats in the slot's round end.
//
//   CLOSED END FACES THE SOURCE SPOOL, so wire tension pulls the spigot INTO
//   its seat rather than out of the slot.
//
// The lip's underside is a 45° slope, so it prints with no support and still
// stops the rim: the flange can lift 0.9 mm at the edge — under a degree of
// tilt — before it is on the slope, and the spigot is still 3.3 mm engaged.
// A half-round of lip is enough for every direction, because tipping toward the
// open side still has to lift the rim at ±90°, where the lip is.
//
// GATE: two ⌀2.0 blind holes at the open side. If cranking walks the spool back
// out of the slot, stand a stub of 1.75 filament in one — the same pin and the
// same hole size as the thermal mount's index, which is known to fit.
FENCE_CLR   = 0.5;                       // radial, flange rim to fence wall — it must spin
FENCE_WALL  = 3.0;
FENCE_RW    = FLANGE_D/2 + FENCE_CLR;    // 28.5
FENCE_RO    = FENCE_RW + FENCE_WALL;     // 31.5
LIP_GAP     = 0.4;                       // above the flange's top face, at the wall
LIP_IN      = 1.8;                       // how far the lip leans in over the rim
LIP_LAND    = 1.0;                       // flat on top of the slope
LIP_Z0      = LOW_FL_T + LIP_GAP;        // 3.4 above the plate
FENCE_H     = LIP_Z0 + LIP_IN + LIP_LAND;// 6.2
FENCE_SINK  = 0.5;                       // buried in the plate — a partial-area join
RAIL_L      = 14;                        // straight rails past the centreline
GATE_D      = 2.0;                       // 1.75 filament, as the thermal mount's IDX_D
GATE_R      = FLANGE_D/2 + 0.3 + 1.75/2; // pin just clear of the rim
GATE_A      = 25;                        // degrees off the slot, so it misses the slot
GATE_DEPTH  = 5;
assert(FENCE_RO < WIND_NX*GF/2 - 0.25, "Fence is wider than the plate.");
assert(GATE_R*sin(GATE_A) > WIND_SOCK_D/2 + GATE_D/2 + 1, "Gate hole breaks into the slot.");

// r, z — z = 0 is the plate's top face
function _fence_profile() = [
    [FENCE_RW,          -FENCE_SINK],
    [FENCE_RO,          -FENCE_SINK],
    [FENCE_RO,           FENCE_H],
    [FENCE_RW - LIP_IN,  FENCE_H],
    [FENCE_RW - LIP_IN,  FENCE_H - LIP_LAND],
    [FENCE_RW,           LIP_Z0],
];

module _fence() {
    // half-round on the -X side; its two end faces are the profile itself, in
    // the x = 0 plane, and the rails start on exactly that face — a FULL-face
    // join, so they butt rather than overlap
    rotate([0, 0, 90]) rotate_extrude(angle = 180, $fn = 128) polygon(_fence_profile());
    for (m = [0, 1]) mirror([0, m, 0])
        rotate([90, 0, 90]) linear_extrude(RAIL_L) polygon(_fence_profile());
}

module _winder() {
    difference() {
        union() {
            bin_blank(WIND_NX, WIND_NY, BASE_H);
            translate([0, 0, BASE_H]) _fence();
        }
        // the slot: the old socket, run out through the +X edge
        translate([0, 0, BASE_H - WIND_SOCK_H]) hull() {
            cylinder(d = WIND_SOCK_D, h = WIND_SOCK_H + FENCE_H + 1, $fn = 96);
            translate([WIND_NX*GF, 0, 0]) cylinder(d = WIND_SOCK_D, h = WIND_SOCK_H + FENCE_H + 1, $fn = 96);
        }
        for (s = [-1, 1])
            translate([GATE_R*cos(GATE_A), s*GATE_R*sin(GATE_A), BASE_H - GATE_DEPTH])
                cylinder(d = GATE_D, h = GATE_DEPTH + 1, $fn = 32);
    }
}

CRANK_FLAT_AF = 12.0;    // matches the journal's flats
CRANK_JOURNAL = 14.60;
CRANK_CLR     = 0.35;    // it has to drop on and pull off, not be fought
CRANK_ARM     = 45;      // socket centre to grip centre
CRANK_T       = 8;       // arm thickness
CRANK_GRIP_D  = 14;

// THE FIRST CRANK WOULD NOT STAY ON, and the arithmetic says why. Nothing holds
// it down but the hand, and a push on the grip tips it about the edge of whatever
// it is sitting on. It sat on the JOURNAL'S TOP — the socket was 5.2 deep on a
// 5.5 journal, so the hub hung 0.3 above the flange — with a ⌀22.6 hub as its
// only footing and a 26 mm grip to lever against. Staying on needed a downward
// push of about 1.9x the winding force. Nobody cranks like that, so it walked
// up the 5 mm socket and off.
//
//   footing      ⌀22.6 hub on the journal  ->  ⌀54 disc flat on the ⌀56 flange
//   socket       5.2 deep, bottoms first   ->  6.2 deep, so the DISC lands first
//   grip         26 tall                   ->  18 tall, a lower lever
//
// Down-push needed drops to about 0.6x the winding force, which is just the
// weight of a hand on the grip. Spool unchanged: this is a crank-only reprint.
JOURNAL_EXPOSED = SHAFT_L - JOURNAL_BOT;   // 5.5, read from spool_common
CRANK_DEPTH   = 6.2;
CRANK_DISC_D  = 54;      // inside the ⌀56 flange so it never overhangs the rim
CRANK_GRIP_H  = 18;
assert(CRANK_DEPTH > JOURNAL_EXPOSED + 0.5, "Socket must clear the journal top or the disc never lands on the flange.");
assert(CRANK_T - CRANK_DEPTH >= 1.6, "Socket ceiling too thin.");

// The upper flange's anchor slot sits at r 15.6..17.2, in line with the flats —
// so under the disc, on one side or the other. A wire tail bent over there would
// hold the disc off the flange. Two through-windows, one per side, leave it room
// and let you see it.
CRANK_WIN_R0  = 12.5;    // 4.5 of wall outside the socket
CRANK_WIN_R1  = 21.0;
CRANK_WIN_W   = 8.0;
