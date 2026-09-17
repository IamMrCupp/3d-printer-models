# Wick and solder spool

A **shaft that is a spool**, for the downloaded [1×3 Gridfinity Wick and Solder Spool Holder](https://www.thingiverse.com/). It replaces that model's plain shaft. The base and both brackets are unchanged — nothing already printed needs reprinting.

![preview](preview.png)

## Why it exists

The holder's shaft is ⌀14.60 and small-bore spools will not pass it; only its ⌀10.00 spigot is narrow enough. Narrowing the shaft does not work, because the ⌀14.60 is what locates it in the top bracket's ⌀15.00 bore — and a shaft needs a shoulder above ⌀10 to sit on the bottom bracket, so a spool that only clears ⌀10 cannot get past either end.

Winding onto the shaft itself removes the problem: there is no spool bore to match, because you are making the bore.

## Mounting — measured, do not change

Taken off the supplied STLs. The existing brackets are being kept, so none of it may move.

| | |
|---|---|
| bottom bracket bore | ⌀10.00, grips shaft-local z 0.15–3.65 |
| top bracket bore | ⌀15.00, grips shaft-local z 37.90–41.40 |
| overall length | 41.50 mm |
| free span between brackets | 34.25 mm |
| envelope before the flange fouls the bracket | ⌀60.0 |

⚠️ **The spigot is ⌀9.70, not ⌀10.00, and that is deliberate.** The original shaft was ⌀10.00 in a ⌀10.00 bore — a slip fit that never had to turn, because the spool spun on the shaft. Here the shaft *is* the spool, so that bore is a journal bearing now. At zero clearance it will not pay out wire at all. 0.30 mm matches the intent of the top journal's existing 0.40.

## Two parts, and the split is for printing

Printed upright in one piece, both flange undersides are flat ceilings. Making them self-supporting costs 45° cones that eat 20–37 mm of a 34 mm span — ⌀48 and up will not fit at all, and the self-supporting version collapses to **6.9 cm³**.

Splitting at the **upper flange's underside** gives 53.7 cm³ with no towers:

| part | print | support |
|---|---|---|
| `spool_lower.scad` | spigot-down, as emitted | a short ring under the lower flange, 3.80 mm above the bed |
| `spool_upper.scad` | flange-down, as emitted — 2463 mm² on the bed | **none** |

**Getting `spool_lower` off the plate.** The only model touching the bed is the ⌀9.70 spigot. The ⌀56 flange is sitting on that support ring, and in PETG the ring is what holds the part down. Let the plate cool all the way and flex it; do not lever the flange up with a scraper. The first print was pried, and the hub sheared off the flange — see below.

⚠️ **Do not split it mid-hub.** That was the first idea and it is wrong: the upper half becomes hub-then-flange, which overhangs whichever way up you print it.

## The joint

The two halves are trapped between the brackets once installed, so the joint only has to survive winding and handling — which are exactly what a plain friction fit is worst at. So it does both jobs explicitly:

- a **flat** on the ⌀10 boss carries torque, so cranking does not rely on friction
- a **ring ridge** snaps into a groove, so it does not come apart when carried

The ridge is two stacked cones rather than a torus. A torus meets the bore on a tangent line, and tangency in a boolean is what this repo keeps paying for.

## The hub sheared off the lower flange — and the fix

The first `spool_lower` came off the plate in two pieces: the flange stayed on the support ring and the hub came away with the spool. The profile met the flange with a sharp 90° corner, on a layer line, and the flange was 2.5 mm. Prying a ⌀56 disc off the plate puts the whole lever into that corner, and a ⌀24 hub on a 2.5 mm flange is not much of a corner to hold it.

Two changes, both in `spool_common.scad`:

- **`HUB_FILLET` 3.0** — the corner is a quarter-round now, so the load spreads across several layers instead of one.
- **`LOW_FL_T` 3.0** — the lower flange is 0.5 mm thicker. The upper flange stays 2.5; it prints face-down and is never pried.

Cost: 0.5 mm of winding width. The upper part is unchanged apart from its anchor slot, so any already-printed `spool_upper` still fits.

## Anchor slot

Each flange has one **4.5 × 1.6 mm slot** through it, hard against the hub, in line with the joint's flat. Poke the start of the wire or braid down through the slot and bend it over on the far face; the first turn traps it. No tape. The braid goes through flat-wise. One slot per flange so a start can be anchored at either end.

## Capacity

⌀56 flanges over a ⌀24 hub, 26.7 mm of winding width — **53.7 cm³**.

`HUB_D` is also the tightest bend the braid sees; raise it if the braid resists the wind.

## Respooler — with a crank

Winding 15 m of braid is **126–149 turns**. Pinching a ⌀56 flange means re-gripping every half turn —
a doorknob, 140 times. The crank makes it steady winding.

**It drives from outside the holder.** Installed, the spool's journal top is flush with the bracket
(41.40 vs 41.50) and there is nothing to grip. Out of the holder the whole 5.5 mm journal is exposed,
so the spool sits captured in `respool_winder` while you wind, and goes back to the holder to live.

**The journal carries two flats**, 12.00 across a ⌀14.60 body. The flats take the torque so the crank
does not rely on friction, which printed-on-printed never survives. They do not affect the holder —
its bore is ⌀15.00 and round, and the two remaining arcs still locate the journal exactly as before.

A hex socket down the journal's top face was considered first and does not fit: the joint socket
already eats 33.50–39.50, leaving 2 mm of solid. Flipping the joint to free it would put the upper
half's boss below its own bed surface when printed flange-down, costing that part its support-free
print.

### The first crank would not stay on

Nothing holds the crank down but your hand, and a push on the grip tips it about the edge of whatever it is sitting on. The first one sat on the **journal's top**: its socket was 5.2 deep on a 5.5 journal, so the hub hung 0.3 mm above the flange, with a ⌀22.6 hub as its only footing and a 26 mm grip to lever against. Staying on took a downward push of about 1.9× the winding force. It walked up the socket and off.

| | was | is |
|---|---|---|
| footing | ⌀22.6 hub, on the journal top | **⌀54 disc, flat on the ⌀56 upper flange** |
| socket | 5.2 deep — journal bottoms first | 6.2 deep — the disc lands first |
| grip | 26 tall | 18 tall |

The push needed drops to about 0.6× the winding force, which is the weight of a hand on the grip. **Crank-only reprint — the spool is unchanged.** Two windows through the disc sit over the upper flange's anchor slot, either way round, so a bent-over wire tail does not hold the disc off the flange.

Checked assembled, not just as a part: crank against `spool_upper` seated on the flange intersects nothing, and the same check fails with 38 mm³ of overlap when the socket is put back to 5.2.

### The first winder let the spool jump out

The spool stood on a ⌀9.70 spigot, 3.8 mm long, in a 4 mm socket, with nothing holding it down. The wire pulls sideways about 20 mm up the hub, and all that resisted the tip was a 30 g spool's own weight — about 40 gf of tension turns it over, and the drag washer asks for more than that. Each time it tipped, the spigot cleared the socket and the wind sprang loose.

**`respool_winder` now holds the lower flange down.** A U-shaped fence wraps the flange, with a lip leaning in over its rim; the socket became a slot out to the open edge. Slide the spool in along the slot, flange under the lip, until the spigot seats in the slot's round end. It spins freely and cannot tip out.

- **Closed end toward the source spool**, so wire tension pulls the spigot into its seat.
- **Gate:** two ⌀2 holes at the open side. If cranking walks the spool back out, stand a stub of 1.75 filament in one.
- The lip's underside is a 45° slope — no supports.
- The lip takes the last 1.3 mm of radial fill at the bottom 3 mm of the winding space. Wind to ⌀53 there and nothing rubs.

Checked against the real `spool_lower`, assembled: seated and spinning it touches nothing; it slides in along the whole slot touching nothing; lifted 2 mm it is on the lip. Tipped about its own rim, the lip stops it at **1.2°** toward the open side or sideways and **1.8°** toward the closed end — the direction the wire pulls, where only the lip at the rails' roots is in play. The spigot does not clear its socket until **7.8°**.

## Source stand

The printed spool already spins in the holder's own brackets; that is what its 0.30 mm spigot and
0.40 mm journal clearances are for. Winding 15 m of 3 mm braid is only **~126–149 turns** on a ⌀56
flange you can grip. So you turn it by hand and the stand just feeds it.

An earlier sketch had a crank, a driven upright, and two flats milled on the journal to drive it —
a spool revision for a problem that does not exist.

**The existing holder cannot host the source spools.** Both fail, for different reasons, which is the
only reason a stand is needed:

| source spool | | |
|---|---|---|
| solder braid | ⌀48.50 × 44.75 wide, bore 10.25 | 44.75 wide vs a 34.25 mm span — **too wide** |
| micro wire #1/#2 | ⌀69.13 × 13.50 wide, bore 11.30 | ⌀69.13 vs a ⌀60 envelope — **too big** |

The ⌀9.9 post clears both bores. The drag washer is what makes the wind tight: without it the source
overruns whenever you pause. Its own weight supplies the drag — deliberately not a spring, because a
printed spring at this size relaxes and this has to behave the same on a 44.75 mm spool and a 13.50
mm one.

## Parts

| file | what |
|---|---|
| `spool_common.scad` | measured mounting dimensions, envelope, joint |
| `spool_lower.scad` | spigot, lower flange, full hub, joint boss |
| `spool_upper.scad` | upper flange, journal, joint socket |
| `respool_common.scad` | source-spool dimensions and stand geometry |
| `respool_stand.scad` | 2×2 base + ⌀9.9 post — 83.5 × 83.5 × 64 mm, ~67 g |
| `respool_drag_washer.scad` | ⌀40 × 6 disc — ~9 g |
| `respool_winder.scad` | 2×2 plate with a spigot slot and a lipped U fence that holds the spool's lower flange down — ~65 g |
| `respool_crank.scad` | D-socket crank on a ⌀54 disc that bears on the upper flange — ~32 g solid, less at normal infill |
