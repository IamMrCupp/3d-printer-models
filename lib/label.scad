// label.scad — two-colour flat-inset text labels, shared across the bench system.
//
// Generalizes the technique proven in donation-qr-stand/: the text is a recessed
// pocket in the light part, filled flush by a matching inlay printed in the dark
// colour. On a multi-toolhead printer (Snapmaker U1) load both parts at the same
// origin and assign a colour to each. Flush beats raised relief — nothing to
// catch, nothing to peel, and it survives an IPA wipe, which a printed sticker
// does not.
//
// Both modules emit the label occupying z ∈ [-LABEL_T, 0], so the caller
// translates to the face being labelled and the inlay tops out flush:
//
//     difference() { my_bin(); translate([0, 30, top_z]) label_pocket("0.45"); }
//     translate([0, 30, top_z]) label_inlay("0.45");            // dark part
//
// Single-colour fallback: label_pocket() alone gives an engraved label that
// still reads, just without the contrast.

LABEL_T    = 0.8;                            // pocket depth = inlay thickness
LABEL_FONT = "Liberation Sans:style=Bold";   // renders locally and in CI
_L_EPS     = 0.02;                           // pocket overrun so difference() is clean

// 2D text outline, centred on the origin by default.
module label_2d(txt, size = 6, font = LABEL_FONT, halign = "center", valign = "center") {
    text(txt, size = size, font = font, halign = halign, valign = valign);
}

// Solid to SUBTRACT from the light part. Overruns the face so the cut is clean.
module label_pocket(txt, size = 6, depth = LABEL_T, font = LABEL_FONT,
                    halign = "center", valign = "center") {
    translate([0, 0, -depth])
        linear_extrude(depth + _L_EPS) label_2d(txt, size, font, halign, valign);
}

// Solid to ADD to the dark part. Fills the pocket flush — no overrun.
module label_inlay(txt, size = 6, depth = LABEL_T, font = LABEL_FONT,
                   halign = "center", valign = "center") {
    translate([0, 0, -depth])
        linear_extrude(depth) label_2d(txt, size, font, halign, valign);
}

// Same pair for a text label on a VERTICAL face (bin front, divider tab), where
// the labelled surface faces +Y. Label occupies y ∈ [-LABEL_T, 0].
module label_pocket_v(txt, size = 6, depth = LABEL_T, font = LABEL_FONT) {
    rotate([90, 0, 0]) translate([0, 0, -_L_EPS])
        linear_extrude(depth + _L_EPS) label_2d(txt, size, font);
}

module label_inlay_v(txt, size = 6, depth = LABEL_T, font = LABEL_FONT) {
    rotate([90, 0, 0]) linear_extrude(depth) label_2d(txt, size, font);
}
