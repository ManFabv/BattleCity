extends WeaponInterface
class_name NormalWeapon


## the weapon will handle the shot, instantiating the projectile and firing it
func try_shot(on_projectile_spawned: BaseEvent) -> void:
	# we instantiate the projectile
	var shot : Projectile = _weapon_config.projectile_scene.instantiate() as Projectile
	# we make it top level to avoid any transform issues
	shot.top_level = true
	# we add the shot to the scene (after this ready function will be triggered)
	on_projectile_spawned.emit(shot)
	# we configure the shot with the weapon values
	shot.configure(_weapon_config.weapon_color, _weapon_config.projectile_max_speed, _weapon_config.projectile_damage_points)
	# we fire the shot from the muzzle
	shot.fire(_muzzle.global_position, _muzzle.global_transform.basis.z)
