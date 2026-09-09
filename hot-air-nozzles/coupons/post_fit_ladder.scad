// post_fit_ladder — four posts, four diameters. Find the one the nozzle slips on.
//
// The rack shipped with ⌀22.29 posts (band ID 22.69 less 0.40) and the nozzles
// will not go on. The model is correct — the STL measures 22.29 at every height —
// so the clearance is simply too tight once a printed post comes out over
// nominal. Sanding nine posts is a bad job and iterating a 145 g rack to find the
// number is worse.
//
// NO GRIDFINITY FOOT AND HOLLOW POSTS, on purpose. This is a gauge, not a part:
// a solid gridfinity version would be most of the rack's mass, which defeats the
// point of gauging. ~20 g against 145.
//
// Slip a nozzle onto each. Take the SMALLEST that goes on without force and
// still feels located, and give me that number — it becomes POST_CLR.
//
// PRINT: flat, as emitted. No supports.

BAND_ID = 22.69;                       // calipered 2026-09-07
CLR     = [0.40, 0.70, 1.00, 1.30];    // the ladder, in diametral clearance

POST_H   = 10;      // enough to judge the fit; the real post is 18
WALL     = 2.0;     // hollow — this is a gauge, not a part
PLATE_T  = 3;
PITCH    = 30;
MARGIN   = 12;
TXT      = 4.5;

W = (len(CLR)-1)*PITCH + 2*MARGIN;
D = 32;
EPS = 0.01;

echo(str("ladder ", W, " x ", D, ", posts ",
         [for (c = CLR) BAND_ID - c]));

difference() {
    union() {
        translate([-W/2, -D/2, 0]) cube([W, D, PLATE_T]);
        for (i = [0 : len(CLR)-1])
            translate([-W/2 + MARGIN + i*PITCH, 0, PLATE_T - EPS])
                difference() {
                    cylinder(d = BAND_ID - CLR[i], h = POST_H + EPS, $fn = 96);
                    translate([0, 0, -EPS])
                        cylinder(d = BAND_ID - CLR[i] - 2*WALL, h = POST_H + 3*EPS, $fn = 96);
                }
    }
    // the clearance engraved beside each post, so a loose one is identifiable
    for (i = [0 : len(CLR)-1])
        translate([-W/2 + MARGIN + i*PITCH, -D/2 + 3.5, PLATE_T - 0.6])
            linear_extrude(0.6 + EPS)
                text(str(CLR[i]), size = TXT, halign = "center", $fn = 32);
}
