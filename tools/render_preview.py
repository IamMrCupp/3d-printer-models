"""Render a studio-style product preview of an STL with Blender, headless.

    blender -b -P tools/render_preview.py -- <input.stl> <output.png>

Soft 3-point sun lighting, a shadow-catcher floor over a gradient backdrop, a
bevelled matte-plastic material, a perspective 3/4 camera framed from the mesh
bounds, and AgX tone-mapping. Scale-robust (sun lights) so it works for a 40 mm
bin or a 500 mm case. CYCLES on CPU; denoises when the build supports it.
"""
import math
import sys

import bpy
from mathutils import Vector

argv = sys.argv[sys.argv.index("--") + 1:]
if len(argv) < 2:
    raise SystemExit("usage: blender -b -P render_preview.py -- <in.stl> <out.png> [#hexcolor]")
stl_path, out_png = argv[0], argv[1]

def _srgb_to_linear(c):
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4

def _hex_color(s, fallback=(0.82, 0.42, 0.14)):
    s = s.lstrip("#")
    if len(s) != 6:
        return (*fallback, 1.0)
    rgb = tuple(int(s[i:i+2], 16) / 255.0 for i in (0, 2, 4))
    return (*tuple(_srgb_to_linear(c) for c in rgb), 1.0)

# optional 3rd arg: hex color (e.g. #d2741f). Default warm orange.
OBJECT_COLOR = _hex_color(argv[2]) if len(argv) >= 3 else _hex_color("d26b1f")

# --- clean scene ---------------------------------------------------------
bpy.ops.wm.read_factory_settings(use_empty=True)
scene = bpy.context.scene

# --- import STL (operator name varies by Blender version) ----------------
imported = False
for op in (lambda: bpy.ops.wm.stl_import(filepath=stl_path),
           lambda: bpy.ops.import_mesh.stl(filepath=stl_path)):
    try:
        op(); imported = True; break
    except (AttributeError, RuntimeError):
        continue
if not imported:
    raise SystemExit("no working STL importer in this Blender build")

obj = next(o for o in scene.objects if o.type == "MESH")
bpy.context.view_layer.objects.active = obj
obj.select_set(True)
bpy.ops.object.origin_set(type="ORIGIN_GEOMETRY", center="BOUNDS")
obj.location = (0.0, 0.0, obj.dimensions.z / 2.0)   # sit on the floor (z=0)
size = max(obj.dimensions) or 1.0

# rounded edges so they catch light like a printed part
bev = obj.modifiers.new("bevel", "BEVEL")
bev.width = max(size * 0.0015, 0.3); bev.segments = 2
bev.limit_method = "ANGLE"; bev.angle_limit = math.radians(35)

# --- material ------------------------------------------------------------
mat = bpy.data.materials.new("plastic")
mat.use_nodes = True
bsdf = mat.node_tree.nodes.get("Principled BSDF")
if bsdf:
    bsdf.inputs["Base Color"].default_value = OBJECT_COLOR
    if "Roughness" in bsdf.inputs:
        bsdf.inputs["Roughness"].default_value = 0.45
obj.data.materials.clear(); obj.data.materials.append(mat)

# --- shadow-catcher floor ------------------------------------------------
bpy.ops.mesh.primitive_plane_add(size=size * 40, location=(0, 0, 0))
floor = bpy.context.active_object
floor.is_shadow_catcher = True

# --- gradient backdrop ---------------------------------------------------
world = bpy.data.worlds.new("world"); scene.world = world; world.use_nodes = True
wnt = world.node_tree
bg = wnt.nodes["Background"]
tc = wnt.nodes.new("ShaderNodeTexCoord")
sep = wnt.nodes.new("ShaderNodeSeparateXYZ")
ramp = wnt.nodes.new("ShaderNodeValToRGB")
ramp.color_ramp.elements[0].position = 0.35
ramp.color_ramp.elements[0].color = (0.045, 0.05, 0.06, 1)   # darker low
ramp.color_ramp.elements[1].position = 0.85
ramp.color_ramp.elements[1].color = (0.22, 0.24, 0.27, 1)    # lighter high
wnt.links.new(tc.outputs["Window"], sep.inputs["Vector"])
wnt.links.new(sep.outputs["Y"], ramp.inputs["Fac"])
wnt.links.new(ramp.outputs["Color"], bg.inputs["Color"])

# --- 3-point sun lighting (scale-independent) ----------------------------
def sun(name, energy, rot, angle_deg):
    d = bpy.data.lights.new(name, "SUN"); d.energy = energy; d.angle = math.radians(angle_deg)
    o = bpy.data.objects.new(name, d); scene.collection.objects.link(o)
    o.rotation_euler = [math.radians(a) for a in rot]
sun("key",  4.0, (55, 0, 35), 6)     # key, soft
sun("fill", 1.3, (65, 0, -60), 10)   # fill from the other side
sun("rim",  3.0, (-50, 0, 200), 4)   # rim/back

# --- perspective camera, framed from the world-space bounding sphere ------
bpy.context.view_layer.update()
corners = [obj.matrix_world @ Vector(c) for c in obj.bound_box]
bb_min = Vector(min(c[i] for c in corners) for i in range(3))
bb_max = Vector(max(c[i] for c in corners) for i in range(3))
center = (bb_min + bb_max) / 2
radius = (bb_max - bb_min).length / 2 or 1.0

cam_data = bpy.data.cameras.new("cam"); cam_data.type = "PERSP"; cam_data.lens = 70
cam_data.clip_end = radius * 20
cam = bpy.data.objects.new("cam", cam_data); scene.collection.objects.link(cam); scene.camera = cam
# fit the bounding sphere to the (narrower) vertical FOV so any shape fits
fov_h = 2 * math.atan((cam_data.sensor_width / 2) / cam_data.lens)
fov_v = 2 * math.atan(math.tan(fov_h / 2) * 1200 / 1600)
dist = radius / math.sin(min(fov_h, fov_v) / 2) * 1.12
cam.location = center + Vector((0.6, -1.0, 0.55)).normalized() * dist
cam.rotation_euler = (center - cam.location).to_track_quat("-Z", "Y").to_euler()

# --- render --------------------------------------------------------------
scene.render.engine = "CYCLES"
scene.cycles.samples = 160
scene.cycles.device = "CPU"
try:
    scene.cycles.use_denoising = True          # clean when the build has a denoiser
except Exception:
    pass
try:
    scene.view_settings.view_transform = "AgX"  # filmic tone-mapping (Blender 4.0+)
except Exception:
    pass
scene.render.film_transparent = False
scene.render.resolution_x = 1600
scene.render.resolution_y = 1200
scene.render.image_settings.file_format = "PNG"
scene.render.filepath = out_png
bpy.ops.render.render(write_still=True)
print(f"wrote {out_png}")
