// bin_probe_leads — one bucket for the probe and the alligator lead.
//
// Sits BEHIND the Shortkiller in ONE of the two rear cells. The other rear cell
// stays empty — the Shortkiller's DC cord is not detachable and needs that route. The probe stands
// TIP-DOWN in a blind tube rising from the bin floor; the alligator lead drapes
// into the open well around that tube. Both stay plugged into the Shortkiller's
// GX12 connector — you drop them in, you don't unplug and coil them.
//
// Tip-down is deliberate: the sharp end is buried in plastic and you grab the
// handle. Same reasoning as the UV lamp holster in phase-2 (B.5).
//
// The wall facing the Shortkiller is cut down to LEADS_FACE_H so this bin does
// not shadow the box's rear DC jack and rocker switch.
//
// PRINT: flat, foot down, no supports. The tube is self-supporting.
include <../lib/gridfinity.scad>
include <shortkiller_common.scad>

LW      = NX_LEADS * GF - 0.5;
LD      = NY_LEADS * GF - 0.5;
LFLOOR  = BIN_BASE_H + FLOOR_T;          // no flare on this bin — stock floor
TUBE_ID = PROBE_D + PROBE_CLR;
TUBE_OD = TUBE_ID + 2 * PROBE_WALL;

module bin_probe_leads() {
    union() {
        difference() {
            bin_blank(NX_LEADS, NY_LEADS, LEADS_BIN_H);

            // open well
            translate([0, 0, LFLOOR])
                linear_extrude(LEADS_BIN_H)
                    offset(BIN_R - LEADS_WALL) offset(-(BIN_R - LEADS_WALL))
                        square([LW - 2 * LEADS_WALL, LD - 2 * LEADS_WALL],
                               center = true);

            // cut the wall facing the Shortkiller (-Y) down to LEADS_FACE_H
            // NB: overshoot past the well's inner face. Ending flush with it
            // leaves a coincident face and the mesh goes non-manifold.
            translate([-LW / 2 - 1, -LD / 2 - 1, LFLOOR + LEADS_FACE_H])
                cube([LW + 2, LEADS_WALL + 6, LEADS_BIN_H]);
        }

        // probe tube, floor to rim
        translate([0, PROBE_OFFSET, LFLOOR])
            difference() {
                cylinder(d = TUBE_OD, h = LEADS_BIN_H - LFLOOR);
                translate([0, 0, FLOOR_T])
                    cylinder(d = TUBE_ID, h = LEADS_BIN_H);   // blind — tip sits on FLOOR_T
            }
    }
}

bin_probe_leads();
