class_name DoubleFastWeapon
extends Weapon

@export_range(0.1, 10.0) var _shoot_distance_offset: float = 0.2


## Level-two weapon: emits two projectiles and uses the faster fire-rate scene.
func try_shot(muzzle: Marker3D, on_projectile_spawned: BaseEvent) -> void:
	# we instantiate two projectiles
	var left_shot: Projectile = _projectile_scene.instantiate() as Projectile
	var right_shot: Projectile = _projectile_scene.instantiate() as Projectile
	# we make it top level to avoid any transform issues
	left_shot.top_level = true
	right_shot.top_level = true
	# we add the shot to the scene (after this ready function will be triggered)
	on_projectile_spawned.emit(left_shot)
	on_projectile_spawned.emit(right_shot)
	# we fire the shot with a movement scene
	left_shot.fire(muzzle, _continuous_movement_scene)
	right_shot.fire(muzzle, _continuous_movement_scene)
	# we offset the shots
	var offset: Vector3 = muzzle.global_transform.basis.x * _shoot_distance_offset
	left_shot.global_position -= offset
	right_shot.global_position += offset
