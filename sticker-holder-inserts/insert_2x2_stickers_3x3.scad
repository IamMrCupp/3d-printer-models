// insert_2x2_stickers_3x3 — 3×3 grid of pockets (for 2×2-size stickers).
// Render: openscad -o insert_2x2_stickers_3x3.stl insert_2x2_stickers_3x3.scad
use <sticker_insert.scad>

sticker_insert(cols = 3, rows = 3, spacing_x = 54.3, spacing_y = 54.3);
