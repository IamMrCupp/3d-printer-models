# 3d-printer-models

A collection of 3D-printable models — both the finished meshes and, going forward, the source that generates them. Some designs may also be published to sharing sites (Printables, Thingiverse, etc.).

## Models

| Model | What it is | Footprint |
|---|---|---|
| [`sticker-holder-inserts/`](sticker-holder-inserts/) | Drawer/box organizer inserts for sorting sheet stickers by size. Two grid layouts share one outer shell. | 183 × 180 × 30 mm |

## Repo layout

One directory per model. Each model directory aims to carry the full recommended set:

- **`*.stl`** — the printable mesh(es)
- **source / CAD file** — the editable design it was exported from
- **print settings** — recommended slicer settings (material, layer height, infill, supports)
- **per-model notes / license** — anything specific to that model

> Existing models predate this convention and may not yet have every item — they'll be backfilled as they're revisited.

## Printing

Models are exported as STL in millimeters, oriented for printing where practical. Slice with your slicer of choice. Dimensions and orientation are noted per model.

## Development

Models are authored in **OpenSCAD** (`.scad` = source of truth) and rendered to STL; previews are rendered in **Blender**.

```sh
tools/render.sh        # render every model .scad → build/ and validate each mesh
```

`tools/validate_stl.py` checks a mesh is watertight / 2-manifold with a sane bounding box. It uses [trimesh](https://trimesh.org) when available (authoritative) and falls back to a zero-dependency stdlib check otherwise, so it runs even without a venv:

```sh
python3 -m venv .venv && .venv/bin/pip install -r requirements-dev.txt
```

On every PR, the [`validate`](.github/workflows/validate.yml) workflow renders all models and runs the trimesh check — a parameter edit that breaks geometry fails the build.

### Releases

Models are released **independently**. Push a tag shaped `<model-slug>/vX.Y.Z` and the [`release`](.github/workflows/release.yml) workflow renders that model's STL(s) + a Blender preview and publishes a GitHub Release with them attached:

```sh
git tag sticker-holder-inserts/v1.0.0
git push origin sticker-holder-inserts/v1.0.0
```

Build the same artifacts locally with `tools/build_release.sh <model-slug>` (writes to `dist/`).

## License

This repository is licensed under [Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/) — see [`LICENSE`](LICENSE).

You may share and adapt these models **with attribution** and **for non-commercial purposes**. Commercial use (including selling prints) requires permission.

## Attribution / AI disclosure

Authored by Aaron Cupp. Some models and tooling in this repo are developed with assistance from Claude (Anthropic).
