# 3d-printer-models

A collection of 3D-printable models authored as **OpenSCAD source**. STLs are rendered from source and published as [release](https://github.com/IamMrCupp/3d-printer-models/releases) artifacts, not committed. Some designs may also be published to sharing sites (Printables, Thingiverse, etc.).

## Models

| Model | What it is | Footprint |
|---|---|---|
| [`sticker-holder-inserts/`](sticker-holder-inserts/) | Organizer trays with a grid of square pockets for square stickers (2″ and 3″ variants). | 183 × 180 × 30 mm |

## Repo layout

One directory per model. Each model directory carries:

- **source `.scad`** — the editable, parametric design (source of truth)
- **`README.md`** — variants, dimensions, recommended print settings
- STLs are **not** committed — grab them from the model's GitHub Release (rendered + validated by CI)

## Downloading prints

Each model is released independently. Printable STLs + a preview image are attached to the model's GitHub Release (tag `<model-slug>/vX.Y.Z`) — see [Releases](https://github.com/IamMrCupp/3d-printer-models/releases).

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
