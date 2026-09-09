// baseplate_cleaning_5x6 — 5×6 Clickfinity baseplate (210×252 mm) for the cleaning
// zone. Click-latch (magnet-free) bin retention + edge dovetails so it can be
// joined to more plates and expanded later. Bins are standard Gridfinity and drop
// into the click arms unmodified.
//
// Policy: ALL bench baseplates use JOIN = true (male dovetails +X/+Y, female
// slots −X/−Y) so any two plates butt-and-slide to lock.
include <../lib/clickfinity.scad>
JOIN = true;
clickfinity_baseplate(5, 6, arms = true);
