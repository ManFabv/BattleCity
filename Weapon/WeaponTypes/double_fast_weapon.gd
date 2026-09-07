class_name DoubleFastWeapon
extends NormalWeapon

## Level-two weapon: emits two projectiles and uses the faster fire-rate scene.
func try_shot(muzzle: Marker3D, on_projectile_spawned: BaseEvent) -> void:
	var left_shot: Projectile = _projectile_scene.instantiate() as Projectile
	var right_shot: Projectile = _projectile_scene.instantiate() as Projectile
	left_shot.top_level = true
	right_shot.top_level = true
	on_projectile_spawned.emit(left_shot)
	on_projectile_spawned.emit(right_shot)
	left_shot.fire(muzzle, _continuous_movement_scene)
	right_shot.fire(muzzle, _continuous_movement_scene)
	var offset: Vector3 = muzzle.global_transform.basis.x * 0.2
	left_shot.global_position -= offset
	right_shot.global_position += offset
