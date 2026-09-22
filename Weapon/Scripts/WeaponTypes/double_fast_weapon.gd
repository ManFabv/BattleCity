class_name DoubleFastWeapon
extends Weapon

@export_range(0.1, 10.0) var _shoot_distance_offset: float = 0.2


## Level-two weapon: emits two projectiles and uses the faster fire-rate scene.
func try_shot(on_projectile_spawned: BaseEvent) -> void:
	_fire_single_shot(on_projectile_spawned, -1.0)
	_fire_single_shot(on_projectile_spawned, 1.0)


## fires one projectile offset to the given side (-1 left, 1 right)
func _fire_single_shot(on_projectile_spawned: BaseEvent, offset_side: float) -> void:
	# we instantiate the projectile
	var shot : Projectile = _weapon_config.projectile_scene.instantiate() as Projectile
	# we make it top level to avoid any transform issues
	shot.top_level = true
	# we add the shot to the scene (after this ready function will be triggered)
	on_projectile_spawned.emit(shot)
	# we fire the shot with a movement scene
	shot.fire(_muzzle, _projectile_config)
	# we offset the shot to its side
	shot.global_position += _muzzle.global_transform.basis.x * _shoot_distance_offset * offset_side
