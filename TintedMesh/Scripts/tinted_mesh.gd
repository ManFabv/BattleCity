class_name TintedMesh
extends MeshInstance3D

## material owned by this mesh, so tinting never touches a material shared with other instances;
## created up front because apply_color() may be called before this node enters the tree
var _material : StandardMaterial3D = StandardMaterial3D.new()


## we override the first material of the mesh with our own
func _ready() -> void:
	set_surface_override_material(0, _material)


## paints the mesh albedo color
func apply_color(color: Color) -> void:
	_material.albedo_color = color
