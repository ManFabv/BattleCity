class_name LinearProjectileMovementStrategy
extends ProjectileMovementStrategyInterface

var projectile_movement_stats: ProjectileMovementStatsInterface


## direction where the projectile is moving
var _direction : Vector3 = Vector3.FORWARD


func configure(stats: ProjectileMovementStatsInterface, origin: Node3D) -> void:
	projectile_movement_stats = stats
	# we take the origin (usually the shooting point) forward position
	_direction = origin.global_transform.basis.z.normalized()


## function responsible for calculating the movement of projectiles
func move(transform: Transform3D, delta: float) -> Transform3D:
	transform.origin += _direction * projectile_movement_stats.max_speed * delta
	return transform
