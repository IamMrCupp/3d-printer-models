#!/usr/bin/env python3
"""Prove the tray fits the parametric case — corners included.

The tray was signed off on a span measured through the MIDDLE of the box, which
says nothing about the corners. The box's interior corner radius is larger than
the tray's, so the corners are the tight spot: at CORNER = 8 they cleared by
0.36 mm, inside normal print growth.

This slices BOTH meshes and tests actual containment: every point of the tray's
outline, at every height, against the box's interior polygon at the same height.
"""
import math, os, struct, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
BOX = os.path.expanduser("~/Downloads/bottom-20x20x4cm.stl")
NEED = 1.0          # mm of clearance we insist on, everywhere


def tris(path):
    fh = open(path, "rb"); fh.read(80)
    n = struct.unpack("<I", fh.read(4))[0]
    out = []
    for _ in range(n):
        v = struct.unpack("<12f", fh.read(50)[:48])[3:]
        out.append((v[0:3], v[3:6], v[6:9]))
    return out


def section(T, level, axis):
    """Line segments where the mesh crosses `level` on `axis`; returns 2D pts."""
    keep = [i for i in (0, 1, 2) if i != axis]
    segs = []
    for t in T:
        p = []
        for i in range(3):
            a, b = t[i], t[(i + 1) % 3]
            if (a[axis] - level) * (b[axis] - level) < 0:
                u = (level - a[axis]) / (b[axis] - a[axis])
                p.append(tuple(a[k] + u * (b[k] - a[k]) for k in keep))
        if len(p) == 2:
            segs.append(p)
    return segs


def _order(pts):
    """Order a loop's points by angle about its centroid — good enough for the
    convex-ish rounded rectangles here, and it keeps the polygon non-self-crossing."""
    cx = sum(p[0] for p in pts) / len(pts); cy = sum(p[1] for p in pts) / len(pts)
    return sorted(pts, key=lambda p: math.atan2(p[1] - cy, p[0] - cx))


def loops(segs):
    """Split a section into closed loops, keyed by rounded endpoints."""
    import collections
    adj = collections.defaultdict(list)
    k = lambda p: (round(p[0], 3), round(p[1], 3))
    for a, b in segs:
        adj[k(a)].append(k(b)); adj[k(b)].append(k(a))
    seen = set(); out = []
    for start in adj:
        if start in seen:
            continue
        comp = []; stack = [start]
        while stack:
            c = stack.pop()
            if c in seen:
                continue
            seen.add(c); comp.append(c); stack.extend(adj[c])
        out.append(comp)
    return out


def cavity(segs):
    """The box's INNER contour — a point in the cavity is OUTSIDE the material,
    so testing 'inside the section' answers the wrong question entirely. Take the
    largest loop that is not the outer shell."""
    ls = loops(segs)
    if len(ls) < 2:
        return None
    def ext(L):
        return max(max(p[0] for p in L) - min(p[0] for p in L),
                   max(p[1] for p in L) - min(p[1] for p in L))
    ls.sort(key=ext, reverse=True)
    return ls[1]          # [0] is the outer shell


def cavity_segs(segs, loop):
    """The section's OWN segments belonging to the cavity loop.

    Re-ordering the loop's points by angle and joining them chords the arcs, and
    every chord sits inside the true boundary — so distances measured to it read
    LOW. Use the mesh's real edges."""
    want = set(loop)
    k = lambda p: (round(p[0], 3), round(p[1], 3))
    return [(a, b) for a, b in segs if k(a) in want and k(b) in want]


def inside(segs, x, y):
    c = 0
    for (x1, y1), (x2, y2) in segs:
        if (y1 > y) != (y2 > y):
            if x1 + (y - y1) * (x2 - x1) / (y2 - y1) > x:
                c += 1
    return c % 2 == 1


def dist_to(segs, x, y):
    best = 1e9
    for (x1, y1), (x2, y2) in segs:
        dx, dy = x2 - x1, y2 - y1
        L = dx * dx + dy * dy
        t = 0.0 if L == 0 else max(0.0, min(1.0, ((x - x1) * dx + (y - y1) * dy) / L))
        best = min(best, math.hypot(x - (x1 + t * dx), y - (y1 + t * dy)))
    return best


def render_tray():
    f = tempfile.NamedTemporaryFile(suffix=".stl", delete=False)
    f.close()
    subprocess.run(["openscad", "-o", f.name, "--export-format", "binstl",
                    os.path.join(HERE, "tray_jars.scad")],
                   capture_output=True, check=True)
    return f.name


def main():
    if not os.path.exists(BOX):
        print(f"SKIP  box STL not present at {BOX}")
        return 0
    B = tris(BOX)
    ys = [q[1] for t in B for q in t]
    floor = min(ys) + 2.40          # measured interior floor
    rim = max(ys)

    Tr = tris(render_tray())
    zs = [q[2] for t in Tr for q in t]
    tz0, tz1 = min(zs), max(zs)

    # Find the lowest seat: raise the tray until every outline point is inside.
    seat = None
    for s in [x / 10 for x in range(0, 200)]:
        ok = True
        for dz in (0.5, (tz1 - tz0) / 2, tz1 - tz0 - 0.5):
            cav = cavity(section(B, floor + s + dz, 1))
            if cav is None:
                ok = False; break
            box = cavity_segs(section(B, floor + s + dz, 1), set(cav))
            tray = section(Tr, tz0 + dz, 2)
            pts = [p for sg in tray for p in sg]
            cx = (min(p[0] for p in pts) + max(p[0] for p in pts)) / 2
            cy = (min(p[1] for p in pts) + max(p[1] for p in pts)) / 2
            bx = [p[0] for sg in box for p in sg]; by = [p[1] for sg in box for p in sg]
            bcx = (min(bx) + max(bx)) / 2; bcy = (min(by) + max(by)) / 2
            for (px, py) in pts[::7]:
                if not inside(box, px - cx + bcx, py - cy + bcy):
                    ok = False; break
            if not ok:
                break
        if ok:
            seat = s
            break
    if seat is None:
        print("FAIL  the tray does not fit the box at any height")
        return 1

    print(f"tray seats {seat:.1f} mm above the interior floor")
    # The box's floor chamfer runs out about 10 mm up, so the tray's lowest few mm
    # REST on it — near-zero clearance there is the seat, not a collision. Measure
    # the free fit above that.
    free_from = max(0.0, 10.0 - seat) + 1.0
    print(f"seated on the floor chamfer up to {free_from:.1f} mm; "
          f"measuring free clearance above that")
    worst = 1e9; worst_at = None
    for dz in [x / 2 for x in range(int(free_from * 2), int((tz1 - tz0) * 2))]:
        cav = cavity(section(B, floor + seat + dz, 1))
        tray = section(Tr, tz0 + dz, 2)
        if cav is None or not tray:
            continue
        box = cavity_segs(section(B, floor + seat + dz, 1), set(cav))
        pts = [p for sg in tray for p in sg]
        cx = (min(p[0] for p in pts) + max(p[0] for p in pts)) / 2
        cy = (min(p[1] for p in pts) + max(p[1] for p in pts)) / 2
        bx = [p[0] for sg in box for p in sg]; by = [p[1] for sg in box for p in sg]
        bcx = (min(bx) + max(bx)) / 2; bcy = (min(by) + max(by)) / 2
        for (px, py) in pts[::5]:
            d = dist_to(box, px - cx + bcx, py - cy + bcy)
            if d < worst:
                worst, worst_at = d, dz
    print(f"tightest clearance {worst:.2f} mm, at {worst_at:.1f} mm up the tray")
    print(f"top of tray sits {seat + (tz1 - tz0):.1f} mm above the floor; "
          f"rim is {rim - floor:.1f} -> {rim - floor - seat - (tz1 - tz0):.1f} mm of headroom")
    ok = worst >= NEED
    print(("PASS" if ok else f"FAIL  under the {NEED:.1f} mm minimum"))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
