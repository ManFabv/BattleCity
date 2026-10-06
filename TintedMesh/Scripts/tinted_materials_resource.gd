class_name TintedMaterialsResource
extends Resource

## one material per distinct color, shared by every TintedMesh that uses this resource; a material taken from here is never edited
var _materials_by_color : Dictionary[Color, StandardMaterial3D] = {}


## shared material for the given color, created the first time that color is requested
func get_shared_material(color: Color) -> StandardMaterial3D:
	# first time this color is requested: we create its material and keep it
	if not _materials_by_color.has(color):
		# we create the material once for this color
		var shared_material : StandardMaterial3D = StandardMaterial3D.new()
		# we paint it
		shared_material.albedo_color = color
		# we keep it for every next mesh with this color
		_materials_by_color[color] = shared_material
	return _materials_by_color[color]
