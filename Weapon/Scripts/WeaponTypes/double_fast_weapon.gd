class_name DoubleFastWeapon
extends WeaponInterface

@export_group("References")
## where each projectile spawns from, one per barrel; their forward axis is the firing direction
@export var _muzzles : Array[Marker3D]


## fires one projectile from each muzzle
func _fire_projectiles() -> void:
	for muzzle in _muzzles:
		_fire_projectile(muzzle)
