"""Render a preview PNG of an STL with Blender, headless.

    blender -b -P tools/render_preview.py -- <input.stl> <output.png>

Version-robust across Blender 3.x–5.x: tries each STL importer and uses the
CYCLES engine on CPU (reliable in headless CI, no GL context needed). Frames an
orthographic isometric view automatically from the mesh bounds.
"""
import math
import sys

import bpy
from mathutils import Vector

argv = sys.argv[sys.argv.index("--") + 1:]
if len(argv) != 2:
    raise SystemExit("usage: blender -b -P render_preview.py -- <in.stl> <out.png>")
stl_path, out_png = argv

# --- clean scene ---------------------------------------------------------
bpy.ops.wm.read_factory_settings(use_empty=True)

# --- import STL (operator name varies by Blender version) ----------------
imported = False
for op in (
    lambda: bpy.ops.wm.stl_import(filepath=stl_path),       # 4.0+
    lambda: bpy.ops.import_mesh.stl(filepath=stl_path),     # <=3.x (addon)
):
    try:
        op()
        imported = True
        break
    except (AttributeError, RuntimeError):
        continue
if not imported:
    raise SystemExit("no working STL importer in this Blender build")

obj = next(o for o in bpy.context.scene.objects if o.type == "MESH")

# center geometry on the origin
bpy.context.view_layer.objects.active = obj
obj.select_set(True)
bpy.ops.object.origin_set(type="ORIGIN_GEOMETRY", center="BOUNDS")
obj.location = (0.0, 0.0, 0.0)
size = max(obj.dimensions) or 1.0

# --- material ------------------------------------------------------------
mat = bpy.data.materials.new("preview")
mat.use_nodes = True
bsdf = mat.node_tree.nodes.get("Principled BSDF")
if bsdf:
    bsdf.inputs["Base Color"].default_value = (0.90, 0.74, 0.12, 1.0)
    if "Roughness" in bsdf.inputs:
        bsdf.inputs["Roughness"].default_value = 0.5
obj.data.materials.clear()
obj.data.materials.append(mat)

# --- camera: orthographic isometric --------------------------------------
cam_data = bpy.data.cameras.new("cam")
cam_data.type = "ORTHO"
cam_data.ortho_scale = size * 1.9
cam = bpy.data.objects.new("cam", cam_data)
bpy.context.scene.collection.objects.link(cam)
bpy.context.scene.camera = cam
cam.location = Vector((size, -size, size * 0.6))
cam.rotation_euler = (Vector((0, 0, 0)) - cam.location).to_track_quat("-Z", "Y").to_euler()

# --- lighting + world ----------------------------------------------------
sun_data = bpy.data.lights.new("sun", "SUN")
sun_data.energy = 4.0
sun = bpy.data.objects.new("sun", sun_data)
bpy.context.scene.collection.objects.link(sun)
sun.rotation_euler = (math.radians(50), math.radians(12), math.radians(40))

world = bpy.data.worlds.new("world")
bpy.context.scene.world = world
world.use_nodes = True
world.node_tree.nodes["Background"].inputs[0].default_value = (0.05, 0.05, 0.06, 1.0)

# --- render --------------------------------------------------------------
scene = bpy.context.scene
scene.render.engine = "CYCLES"
scene.cycles.samples = 32
scene.cycles.device = "CPU"
# Distro/CI Blender builds often ship without OpenImageDenoise; CYCLES defaults
# to denoising on and errors with "no device available to denoise on". Off.
scene.cycles.use_denoising = False
scene.render.resolution_x = 1200
scene.render.resolution_y = 900
scene.render.image_settings.file_format = "PNG"
scene.render.filepath = out_png
bpy.ops.render.render(write_still=True)
print(f"wrote {out_png}")
