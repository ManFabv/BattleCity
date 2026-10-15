class_name WeaponMesh
extends TintedMesh

@export_group("References")
## where this weapon's projectiles spawn from
@export var muzzle : Marker3D
## the other barrels of this weapon, tinted with the same color as this mesh
@export var _extra_barrel_meshes : Array[TintedMesh]


## we tint this barrel and the extra ones with the same color
func apply_color(color: Color) -> void:
	# this barrel
	super(color)
	# each extra barrel shares the material of that color
	for barrel_mesh in _extra_barrel_meshes:
		barrel_mesh.apply_color(color)
