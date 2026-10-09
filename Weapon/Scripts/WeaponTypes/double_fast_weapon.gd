class_name DoubleFastWeapon
extends WeaponInterface


## fires two projectiles, one to each side of the muzzle
func _fire_projectiles() -> void:
	# we read the muzzle transform once for both projectiles
	var muzzle_transform : Transform3D = _muzzle.global_transform
	# we offset both projectiles the same distance along the muzzle's right axis
	var side_offset : Vector3 = muzzle_transform.basis.x * _weapon_config.shoot_distance_offset
	# left projectile
	_fire_projectile(muzzle_transform.origin - side_offset)
	# right projectile
	_fire_projectile(muzzle_transform.origin + side_offset)
