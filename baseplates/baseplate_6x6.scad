// baseplate_6x6 — 6×6 Clickfinity baseplate (252×252 mm, the largest single-piece
// plate that fits the U1 bed). Click-latch bin retention + edge dovetails (JOIN)
// so plates butt-and-slide to lock. Print as many as a zone needs and join them:
// e.g. two 6×6 side-by-side (A's +X males into B's −X females) = a 12×6 surface.
// With dovetails the footprint is ~255×255 — still clears the 270 mm bed.
include <../lib/clickfinity.scad>
JOIN = true;
clickfinity_baseplate(6, 6, arms = true);
