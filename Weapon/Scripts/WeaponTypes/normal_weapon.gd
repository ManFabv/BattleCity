class_name NormalWeapon
extends WeaponInterface


## fires a single projectile from the muzzle
func _fire_projectiles() -> void:
	_fire_projectile(_muzzle.global_position)
