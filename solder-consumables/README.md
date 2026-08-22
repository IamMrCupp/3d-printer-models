# Solder consumables

![Solder consumables](preview.png)

**Gridfinity** bins for the small consumables that live beside the iron — chip-removal alloy,
rosin, tip tinner.

## Parts

| File | What | Size |
|---|---|---|
| `bin_chip_remover.scad` | 1 × 5 trough for the chip-removal alloy tube | 41.5 × 209.5 × 30 mm |

**Plain bin, not a contoured cradle.** The tube is rigid and the bin has walls; a shaped channel
would only earn its place if the tube had to sit in one particular orientation, and it doesn't.
`TUBE_H` is the only parameter — raise it if the tube stands proud of the rim.

## On the rosin tin — retired

There isn't one. The old tin went off and isn't being replaced; flux now comes from Blackhorse
(in-house rosin flux), in a different container.

**The lid diameter nearly cost a 2×2.** Sized off 42.5 the tin looks impossible in a 1×1 — it's
wider than the unit's whole 41.5 mm footprint. But 42.5 is the lid; the body is 38.38 and drops
straight into a 1×1, with the lid's rim resting on the bin rim so the tin lifts out by the lid.
Measure the part that goes *inside*, not the widest point.

Whatever the Blackhorse flux arrives in will need its own measurement.

## Source

```sh
openscad -o bin_chip_remover.stl --export-format binstl bin_chip_remover.scad
```

## Recommended print settings

| | |
|---|---|
| Material | PLA or PETG |
| Layer height | 0.2 mm |
| Walls | 3 perimeters |
| Infill | 15 % |
| Supports | **None** |
