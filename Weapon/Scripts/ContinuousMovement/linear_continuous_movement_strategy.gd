class_name LinearContinuousMovementStrategy
extends ContinuousMovementStrategy

var continuous_movement_stats: ContinuousMovementStats


## direction where the projectile is moving
var _direction : Vector3 = Vector3.FORWARD


func configure(stats: ContinuousMovementStats) -> void:
	continuous_movement_stats = stats


## here we can setup the strategy before use
func initialize(origin: Node3D) -> void:
	# we take the origin (usually the shooting point) forward position
	_direction = origin.global_transform.basis.z.normalized()


## function responsible for calculating the movement of projectiles
func get_motion(delta: float) -> Vector3:
	return _direction * continuous_movement_stats.max_speed * delta
