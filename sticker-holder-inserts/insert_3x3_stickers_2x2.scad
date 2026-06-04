// insert_3x3_stickers_2x2 — 2×2 grid of pockets (for 3×3-size stickers).
// Render: openscad -o insert_3x3_stickers_2x2.stl insert_3x3_stickers_2x2.scad
use <sticker_insert.scad>

sticker_insert(cols = 2, rows = 2, spacing_x = 79.7, spacing_y = 79.7);
