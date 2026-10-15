class_name NormalWeapon
extends WeaponInterface

@export_group("References")
## where the projectile spawns from; its forward axis is the firing direction
@export var _muzzle : Marker3D


## fires a single projectile from the muzzle
func _fire_projectiles() -> void:
	_fire_projectile(_muzzle)
