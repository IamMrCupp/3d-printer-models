// insert_2x2_stickers_3x3 — 3×3 grid of pockets for 2″ square stickers.
// Render: openscad -o insert_2x2_stickers_3x3.stl --export-format binstl insert_2x2_stickers_3x3.scad
include <sticker_insert.scad>  // include (not use) to import INCH + $fn

sticker_insert(cols = 3, rows = 3, spacing_x = 54.3, spacing_y = 54.3, sticker = 2 * INCH);
