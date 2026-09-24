# Baseplates

Clickfinity baseplates for the bench zones — click-latch (magnet-free) bin retention, plus underside pockets for loose **bowtie keys** that lock butted plates together.

![preview](preview.png)

## Joinable by policy

**All bench baseplates use `JOIN = true`**, which cuts a half-bowtie pocket into the underside of every edge, two per cell. Butt any two plates and their half-pockets line up into one bowtie cavity. A loose key drops into each cavity and neither plate can pull away from it. There is no male or female edge, so any edge meets any edge. Print what a zone needs now and expand later: two 6×6 side by side gives a 12×6 surface.

**Assembly:** lay the plates face-down, butt them together, drop a key into each cavity, and flip them over. The bench traps the keys. Nothing to glue.

**How many keys:** two per cell along each seam. Joining two plates along a 6-cell edge takes 12. `connector_keys.scad` prints 24 by default; set `COUNT` for more. Print a few spares, since they're small and easy to lose.

⚠️ **Never key across a height step.** A key is 1.4 mm tall in a 1.6 mm pocket. A 2 mm drop between two desks is taller than the whole joint, so plates on different levels stay separate keyed islands.

Bins are standard Gridfinity and drop into the click arms unmodified.

## Parts

| file | grid | size |
|---|---|---|
| `baseplate_2x2_test.scad` | 2×2 | test tile — **print two of these first** |
| `baseplate_consumables_4x4.scad` | 4×4 | 168 × 168 mm — syringes / UV / rotary |
| `baseplate_respool_4x2.scad` | 4×2 | 168 × 84 mm — the wick respooler's stand and winder side by side, portable. No JOIN pockets; it never butts against another plate |
| `baseplate_cleaning_5x6.scad` | 5×6 | 210 × 252 mm — the cleaning zone |
| `baseplate_6x6.scad` | 6×6 | 252 × 252 mm — largest single piece the U1 bed takes |
| `connector_keys.scad` | — | 24 bowtie keys, 3.6 × 6.5 × 1.4 mm each, on a 42 × 38 mm sheet |

The keys sit inside the plates' own footprint, so a 6×6 is still 252 × 252 on the 270 mm bed.

## ⚠️ Print the 2×2 test tile first

Two of them, ~20 minutes each. Click a 1×1 bin in — does the latch hold? Key the two tiles together along their shared edge — does the joint hold? That validates latch clearance and `KEY_CLEAR` before you commit to a 7.5-hour plate.

Plates print feet down, no supports. Keys print flat as modelled, in the same filament as the plates so the fit matches. A brim helps, since they have very little bed contact.
