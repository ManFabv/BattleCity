class_name NormalWeapon
extends WeaponInterface


## fires a single projectile from the muzzle
func _fire_projectiles(on_projectile_spawned: BaseEvent) -> void:
	_fire_projectile(on_projectile_spawned, _muzzle.global_position)
