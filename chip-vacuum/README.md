# Chip-puller vacuum bin

![Chip-puller vacuum bin](preview.png)

A **1×2 Gridfinity bin** for a handheld, rechargeable chip-puller vacuum. One cell stands the vacuum upright, bottom end down. The other is a low tray, a quarter of the vacuum side's height, for its spare tip and suction cups, so the tool and its bits lift out together.

## Parts

| Part | File | Size | Print |
|---|---|---|---|
| **Vacuum bin** | `bin_chip_vacuum.scad` | 41.5 × 83.5; 51 mm tall on the vacuum side, 12.8 on the tray side | ×1 — feet down, no supports |

## Sized from the vacuum

Calipered (`survey/MEASUREMENTS.md`, 2026-10-09): **34 × 24 × 170 mm** with its tip on, rectangular with slightly rounded corners. The bottom end is the largest part and goes into the pocket.

- **Pocket 34.6 × 24.6, 45 mm deep.** 0.6 mm of clearance each way. The pocket's corners are square, so the vacuum's rounded corners never touch and the four flat sides do the holding.
- **Closed floor.** The charge port is on the bottom face, but it won't charge standing in the bin, so there's no cable slot.
- **45 mm of a 170 mm body** is a comfort choice. The bin latches into the grid, so nothing tips. It leans less than a degree and leaves plenty to grab.

- **Low parts tray, 39 × 46 mm, 6.6 mm deep.** The tray side stands a quarter of the vacuum side's height, 12.8 mm, so the spare tip and suction cups sit low and in reach. The Gridfinity foot and floor take the bottom 6 mm, which is why the tray itself is shallow. Raise `LOW_FRAC` for a deeper one.

## Checked

A 34 × 24 body seated in the pocket clears all four walls and rests on the floor. A body 1 mm larger collides with it, which confirms the check can fail. The tray has a floor and is open above it, nothing on the tray side stands above 12.8 mm, and the vacuum side is still full height.

## Recommended print settings

| Setting | Value |
|---|---|
| Material | PETG |
| Layer height | 0.2 mm |
| Walls | 3 |
| Infill | 15% |
| Supports | None |
