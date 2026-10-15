class_name DoubleFastWeapon
extends WeaponInterface

@export_group("Config")
## distance from the muzzle to each of the two projectiles, along the muzzle's right axis
@export_range(0.1, 10.0) var _shoot_distance_offset : float = 0.2:
	set(new_value):
		# we prevent negative offsets, which would swap the left and right projectiles
		_shoot_distance_offset = maxf(new_value, 0.0)

## fires two projectiles, one to each side of the muzzle
func _fire_projectiles() -> void:
	# we read the muzzle transform once for both projectiles
	var muzzle_transform : Transform3D = _muzzle.global_transform
	# we offset both projectiles the same distance along the muzzle's right axis
	var side_offset : Vector3 = muzzle_transform.basis.x * _shoot_distance_offset
	# left projectile
	_fire_projectile(muzzle_transform.origin - side_offset)
	# right projectile
	_fire_projectile(muzzle_transform.origin + side_offset)
