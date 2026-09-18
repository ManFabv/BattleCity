class_name LinearProjectileMovementStrategy
extends ProjectileMovementStrategy

var projectile_movement_stats: ProjectileMovementStats


## direction where the projectile is moving
var _direction : Vector3 = Vector3.FORWARD


func configure(stats: ProjectileMovementStats, origin: Node3D) -> void:
	projectile_movement_stats = stats
	# we take the origin (usually the shooting point) forward position
	_direction = origin.global_transform.basis.z.normalized()


## function responsible for calculating the movement of projectiles
func get_motion(delta: float) -> Vector3:
	return _direction * projectile_movement_stats.max_speed * delta
