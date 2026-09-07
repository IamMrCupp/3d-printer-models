// Wick and solder spool — a SHAFT THAT IS A SPOOL, for the 1×3 Gridfinity Wick
// and Solder Spool Holder (downloaded model; base and both brackets unchanged).
//
// It replaces that model's plain shaft. Wire winds directly onto it, so there is
// no spool bore to match — which was the original problem: the holder's ⌀14.60
// shaft is too fat for the small-bore spools, and its ⌀10.00 spigot is the only
// part they will pass over.
//
// EVERY MOUNTING DIMENSION BELOW IS MEASURED OFF THE SUPPLIED STLs, and none of
// them may move — the existing brackets are being kept:
//
//   bottom bracket   ⌀10.00 bore, grips shaft-local z  0.15 .. 3.65
//   top bracket      ⌀15.00 bore, grips shaft-local z 37.90 .. 41.40
//   free span between them                             34.25 mm
//   envelope before the flange fouls the bracket       ⌀60.0
//
// TWO PARTS, AND THE SPLIT IS CHOSEN FOR PRINTING, NOT FOR CONVENIENCE. Printed
// upright in one piece, both flange undersides are flat ceilings. Making them
// self-supporting costs 45° cones that eat 20–37 mm of a 34 mm span, which is
// why ⌀48 and up will not fit at all and the self-supporting version collapses
// to 6.9 cm3. Splitting at the UPPER FLANGE'S UNDERSIDE instead gives:
//
//   lower  spigot-down. Only overhang is the lower flange's underside, 3.80 mm
//          above the bed — a short ring of support, not a tower.
//   upper  flange-down on 2463 mm2. The journal is narrower than the flange, so
//          it steps inward going up: NO overhang at all.
//
// Capacity 58.8 cm3 against 6.9 for a self-supporting one-piece.
//
// The split is NOT in the middle of the hub. That was the first idea and it is
// wrong: it leaves the upper half as hub-then-flange, so the flange overhangs
// whichever way up you print it.

// ---- mounting: measured, do not change ----
SHAFT_L    = 41.50;   // overall — set by the bracket spacing
// THE SPIGOT IS UNDERSIZE ON PURPOSE. The bore is ⌀10.00 and the original shaft
// was ⌀10.00 in it — a slip fit that never had to turn, because the spool spun
// on the shaft. Here the shaft IS the spool, so this is a journal bearing now
// and needs real clearance or it will not pay out wire at all. The top journal
// already had 0.40 (⌀14.60 in a ⌀15.00 bore); this matches that intent.
SPIN_CLR   = 0.30;
SPIGOT_D   = 10.00 - SPIN_CLR;   // ⌀9.70 in the ⌀10.00 bottom bracket bore
SPIGOT_TOP = 3.80;
CHAMFER_D  = 9.10 - SPIN_CLR;    // lead-in, following the spigot down
CHAMFER_H  = 0.55;
JOURNAL_D  = 14.60;   // top bracket bore is 15.00 — 0.40 clearance to spin
JOURNAL_BOT = 36.00;  // covers the bracket's grip at 37.90..41.40

// ---- spool: free choices inside the measured envelope ----
FLANGE_D   = 56;      // [40:2:60] 60.0 is where it fouls the bracket
FLANGE_T   = 2.5;
HUB_D      = 24;      // [16:1:36] also the tightest bend the braid sees
LOW_FL_TOP = 6.30;
UP_FL_BOT  = 33.50;   // hub runs 6.30..33.50 -> 27.2 mm of winding width

// ---- the joint ----
SPLIT_Z    = UP_FL_BOT;   // the upper flange's underside
JOINT_D    = 10.0;        // leaves 2.2 mm of wall inside the ⌀14.60 journal
JOINT_L    = 6.0;
JOINT_CLR  = 0.20;

EPS = 0.01;

assert(FLANGE_D <= 60, "Flange fouls the bracket above ⌀60.");
assert(JOURNAL_BOT < 37.90, "Journal must already be full ⌀ where the bracket grips.");
assert(SPIGOT_TOP > 3.65, "Shoulder must clear the bottom bracket's top face.");
echo(str("winding width ", UP_FL_BOT - LOW_FL_TOP, " mm, capacity ",
         3.14159/4*(FLANGE_D*FLANGE_D - HUB_D*HUB_D)*(UP_FL_BOT - LOW_FL_TOP)/1000, " cm3"));

// EACH HALF IS ITS OWN TURNED PROFILE. There is no cut anywhere.
//
// The first version made one solid and intersected it with a cube at SPLIT_Z to
// get each half. That plane is EXACTLY COINCIDENT with the upper flange's
// underside — a face of the very solid being cut — and OpenSCAD 2021.01, which
// is what CI runs, returns Simple: no for it. 2026.06 renders it clean, which is
// how it looked fine locally.
//
// A rotate_extrude of a single polygon contains no booleans at all, so there is
// nothing to go non-manifold and no coincident faces to trip over.

module _lower_profile() {
    rotate_extrude($fn = 128)
        polygon([
            [0,           0],
            [CHAMFER_D/2, 0],
            [SPIGOT_D/2,  CHAMFER_H],
            [SPIGOT_D/2,  SPIGOT_TOP],
            [FLANGE_D/2,  SPIGOT_TOP],
            [FLANGE_D/2,  LOW_FL_TOP],
            [HUB_D/2,     LOW_FL_TOP],
            [HUB_D/2,     SPLIT_Z],
            [0,           SPLIT_Z],
        ]);
}

// Emitted with its own base at z = 0, which is also how it prints: flange-down.
module _upper_profile() {
    ft = FLANGE_T;
    jb = JOURNAL_BOT - SPLIT_Z;
    tp = SHAFT_L - SPLIT_Z;
    rotate_extrude($fn = 128)
        polygon([
            [0,           0],
            [FLANGE_D/2,  0],
            [FLANGE_D/2,  ft],
            [JOURNAL_D/2, jb],
            [JOURNAL_D/2, tp],
            [0,           tp],
        ]);
}

// ---- the joint ----
SPLIT_Z    = UP_FL_BOT;   // the upper flange's underside
JOINT_D    = 10.0;        // leaves 2.2 mm of wall inside the ⌀14.60 journal
JOINT_L    = 6.0;
JOINT_CLR  = 0.20;

EPS = 0.01;

assert(FLANGE_D <= 60, "Flange fouls the bracket above ⌀60.");
assert(JOURNAL_BOT < 37.90, "Journal must already be full ⌀ where the bracket grips.");
assert(SPIGOT_TOP > 3.65, "Shoulder must clear the bottom bracket's top face.");
echo(str("winding width ", UP_FL_BOT - LOW_FL_TOP, " mm, capacity ",
         3.14159/4*(FLANGE_D*FLANGE_D - HUB_D*HUB_D)*(UP_FL_BOT - LOW_FL_TOP)/1000, " cm3"));

// The whole spool as one turned profile. A rotate_extrude of a single polygon
// has no booleans in it at all — nothing to go non-manifold, and no coincident
// faces of the kind that cost this repo a week on the thermal mount.
module _spool_solid() {
    rotate_extrude($fn = 128)
        polygon([
            [0,            0],
            [CHAMFER_D/2,  0],
            [SPIGOT_D/2,   CHAMFER_H],
            [SPIGOT_D/2,   SPIGOT_TOP],
            [FLANGE_D/2,   SPIGOT_TOP],
            [FLANGE_D/2,   LOW_FL_TOP],
            [HUB_D/2,      LOW_FL_TOP],
            [HUB_D/2,      UP_FL_BOT],
            [FLANGE_D/2,   UP_FL_BOT],
            [FLANGE_D/2,   UP_FL_BOT + FLANGE_T],
            [JOURNAL_D/2,  JOURNAL_BOT],
            [JOURNAL_D/2,  SHAFT_L],
            [0,            SHAFT_L],
        ]);
}

// ---- the joint ------------------------------------------------------------
// A press fit alone would do the job while the spool is installed — the two
// brackets trap it top and bottom, so nothing can pull it apart in use. It has
// to survive WINDING and HANDLING, which are the two loads a plain friction fit
// is worst at, so the joint does both explicitly:
//
//   the FLAT carries torque, so cranking does not rely on friction
//   the RIDGE snaps into a groove, so it does not fall apart when carried
//
// The ridge is two stacked cones, not a torus. A torus meets the bore on a
// tangent line, and tangency in a boolean is what this repo keeps paying for.
JOINT_FLAT = 4.0;     // flat at this distance from the axis — the key
RIDGE_Z    = 3.6;     // up the boss
RIDGE_H    = 0.4;     // each cone
RIDGE_OUT  = 0.4;     // how far it stands proud

JOINT_SINK = 0.5;   // how far the boss buries into the hub — see spool_lower

module _joint_boss(len = JOINT_L) {
    difference() {
        union() {
            cylinder(d = JOINT_D, h = len, $fn = 96);
            translate([0, 0, len - JOINT_L + RIDGE_Z]) {
                cylinder(r1 = JOINT_D/2, r2 = JOINT_D/2 + RIDGE_OUT, h = RIDGE_H, $fn = 96);
                translate([0, 0, RIDGE_H])
                    cylinder(r1 = JOINT_D/2 + RIDGE_OUT, r2 = JOINT_D/2, h = RIDGE_H, $fn = 96);
            }
        }
        // the key flat, cut clean through
        translate([JOINT_FLAT, -JOINT_D, -EPS])
            cube([JOINT_D, 2*JOINT_D, len + 2*EPS]);
    }
}

module _joint_socket() {
    c = JOINT_CLR;
    difference() {
        union() {
            cylinder(d = JOINT_D + 2*c, h = JOINT_L + c, $fn = 96);
            translate([0, 0, RIDGE_Z - c]) {
                cylinder(r1 = JOINT_D/2 + c, r2 = JOINT_D/2 + RIDGE_OUT + c, h = RIDGE_H, $fn = 96);
                translate([0, 0, RIDGE_H])
                    cylinder(r1 = JOINT_D/2 + RIDGE_OUT + c, r2 = JOINT_D/2 + c, h = RIDGE_H + 2*c, $fn = 96);
            }
        }
        translate([JOINT_FLAT + c, -JOINT_D, -EPS])
            cube([JOINT_D, 2*JOINT_D, JOINT_L + 2*EPS]);
    }
}
