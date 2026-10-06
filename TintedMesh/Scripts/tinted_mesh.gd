class_name TintedMesh
extends MeshInstance3D

@export_group("References")
## the shared materials, one per color for every tinted mesh
@export var _tinted_materials : TintedMaterialsResource


## paints the mesh by assigning the shared material of the given color; it can be called before entering the tree
func apply_color(color: Color) -> void:
	# we override the first surface with the material of that color
	set_surface_override_material(0, _tinted_materials.get_shared_material(color))
