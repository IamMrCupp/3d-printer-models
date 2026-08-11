# Scope baseplate

![Corner-radius gauge set](preview.png)

A Gridfinity platform that drops over the **weighted base of a microscope boom stand** — so the footprint the base occupies goes back to being usable grid.

> **Not the oscilloscope.** This is the *microscope* boom base. The oscilloscope and hot air station get pedestal risers, which are a different model.

## Status

**Gauge only.** The plate itself isn't authored yet — this directory currently holds the calibration coupon that has to be printed before it can be. The plate lands here once the corner radius comes back off the gauge.

## ⚠️ Print the corner gauge first

The plate is a slip-fit skirt at 0.4 mm clearance around a 131.84 × 130.54 mm platform. Every one of those numbers came off calipers except one: the **corner radius**, which calipers can't read. Estimated at 12 mm, never measured.

That's the dimension that decides whether the skirt seats. A corner radius that's wrong by a couple of millimetres hangs the part up on the corners while all four flats look perfect — which reads as "the plate is too small" and sends you re-cutting the wrong number.

`coupons/scope_corner_gauge.scad` is eight female corners, 6 → 20 mm in 2 mm steps, each tallied with notches (1 notch = 6 mm, +2 mm per notch). Print it flat in anything — it's a measuring tool, not a bench part — press each onto a corner of the platform with both legs flat against the straight edges, and read it against a light:

| What you see | What it means |
|---|---|
| Gap in the **middle** of the arc, legs touching | Gauge radius too **big** |
| Gap at the **leg ends**, arc touching | Gauge radius too **small** |
| Contact all the way round | That's your radius |

If it lands between two gauges, note which two — the fix is either the midpoint or a fine gauge at 1 mm steps across that pair.

## Parts

| File | What | Size |
|---|---|---|
| `coupons/scope_corner_gauge.scad` | **Print first** — 8 female corner gauges, 6–20 mm, notch-tallied | 192 × 94 × 3 mm |

`$fn = 96` here is load-bearing, not cosmetic: the arc *is* the measurement, and a coarse one measures a polygon.

## Source

```sh
openscad -o scope_corner_gauge.stl --export-format binstl coupons/scope_corner_gauge.scad
```

## Recommended print settings

| | |
|---|---|
| Material | Anything on the spool — it's a gauge |
| Layer height | 0.2 mm (draft is fine; accuracy is in the arc, not the finish) |
| Walls | 3 perimeters |
| Infill | 15 % |
| Supports | **None** — prints flat |
