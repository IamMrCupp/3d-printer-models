// owon_tray_rail.scad — clamp rail for the OWON SPM8104 top tray.
//
// Part 2 of 2. **Print TWO** (identical, one per side).
//
// Each rail is a hook in section: a lip the tray plate rests on, an upstand that
// captures the plate sideways, and a skirt down the case side. Two M4 machine
// screws per rail (threaded into brass heat-set inserts) press against the case;
// tightening squeezes the case between the two rails AND pins the plate down.
// Nothing pierces the plate, nothing is glued to the instrument, and the whole
// thing lifts off when you back the screws out.
//
// ASSEMBLY: heat an M4 brass insert into each boss (from the OUTER face), then
// thread an M4 machine screw (~16–20 mm) through it. Rubber/felt dot on the tip.
//
// Why screws and not a snap-on friction clamp: PETG creeps under sustained
// tension. A spring clamp would be tight in week one and loose by month three.
// A screw is a positive grip with no standing load — and it absorbs the
// dimensional slop you get between a datasheet and a real case.
//
// PRINT: lay it on the skirt's OUTER face (flange pointing up) — prints as an
// L on its back, no supports. PETG or PLA both fine here; this part isn't a
// spring. Add a felt/rubber dot on each screw tip so it doesn't mar the case.

include <owon_tray_common.scad>

$fn = 64;

// Cross-section in (x, z). The plate rides on the LIP and is captured laterally
// by the UPSTAND — nothing overhangs it (see LIP_IN note in common: a Gridfinity
// bin leaves only 0.25 mm of rim, so there is nothing to hook over).
//   lip      z 0 .. LIP_T           , x  PLATE_W/2-LIP_IN .. SKIRT_IN  (on the lid)
//   upstand  z 0 .. LIP_T+PLATE_H_  , x  SKIRT_IN .. SKIRT_OUT         (beside plate)
//   skirt    z -SKIRT_D .. 0        , x  SKIRT_IN .. SKIRT_OUT         (down the case)
_TOP = LIP_T + PLATE_H_;   // upstand height = flush with the seated plate's top
function _rail_profile() = [
    [PLATE_W/2 - LIP_IN,  0],       // lip inner, underside (rests on the lid)
    [PLATE_W/2 - LIP_IN,  LIP_T],   // lip inner, top — plate sits here
    [SKIRT_IN,            LIP_T],
    [SKIRT_IN,            _TOP],    // upstand inner face, captures the plate
    [SKIRT_OUT,           _TOP],
    [SKIRT_OUT,          -SKIRT_D], // outer face, all the way down the case side
    [SKIRT_IN,           -SKIRT_D],
    [SKIRT_IN,            0],
];

module rail() {
    difference() {
        union() {
            // the hook, extruded along the rail length. rotate([90,0,0]) maps the
            // profile's second coord to world +Z (skirt DOWN, flange UP) and
            // extrudes along -Y; the translate re-centres it.
            translate([0, RAIL_LEN/2, 0]) rotate([90, 0, 0])
                linear_extrude(RAIL_LEN) polygon(_rail_profile());
            // bosses on the outer skirt face — depth for the heat-set insert
            for (y = [-SCREW_Y, SCREW_Y])
                translate([SKIRT_OUT, y, SCREW_Z]) rotate([0, 90, 0])
                    cylinder(h = BOSS_EXT, d = BOSS_OD);
        }
        // insert bore: HS_D from the OUTER boss face, HS_L deep (heat the insert
        // in here). Continues at HS_D through the rest so the screw tip exits the
        // inner face to press the case.
        for (y = [-SCREW_Y, SCREW_Y])
            translate([SKIRT_IN - 1, y, SCREW_Z]) rotate([0, 90, 0])
                cylinder(h = SKIRT_T + BOSS_EXT + 2, d = HS_D);
    }
}

rail();
