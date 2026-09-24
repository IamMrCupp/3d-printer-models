// connector_keys.scad — a batch of bowtie keys for joining baseplates.
// Copied from clickfinity-openscad, where it is MIT. Here it sits in a model
// directory, so it takes the models' license like every other part; the MIT
// original is still upstream. Geometry comes from lib/clickfinity.scad, which is
// identical to upstream for everything KEY_.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
//
// The loose half of the edge joint. Render a plate with JOIN = true, then print
// enough of these to fill its seams.
//
// HOW MANY: each cell edge carries TWO pockets, so a seam n cells long takes
// 2n keys. Joining two 6×3 plates along their 6-cell edge = 12 keys. Print a
// few spares — they're tiny and easy to lose.
//
// ASSEMBLY: lay both plates FACE-DOWN, butt them along the shared edge, drop a
// key into each cavity, flip. The bench traps them; nothing to glue.
//
// PRINT: flat, as modelled. Same filament as the plates so the fit matches.
// A brim helps — they have very little bed contact.

include <../lib/clickfinity.scad>

/* [Batch] */
COUNT = 24;   // [1:100] how many to print — two 6-cell seams
COLS  = 6;    // [1:20] keys per row on the bed

/* [Layout] */
GAP = 4.0;    // [2:0.5:10] mm between keys

/* [Quality] */
$fn = 32;

// Pitch from the key's real footprint, so COLS never overlaps.
_PITCH_X = 2*KEY_REACH + GAP;
_PITCH_Y = KEY_END + GAP;

for (i = [0:COUNT-1])
    translate([(i % COLS) * _PITCH_X, floor(i / COLS) * _PITCH_Y, 0])
        connector_key();
