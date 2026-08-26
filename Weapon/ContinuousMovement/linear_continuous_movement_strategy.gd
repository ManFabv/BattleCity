extends ContinuousMovementStrategy
class_name LinearContinuousMovementStrategy

@export var continuous_movement_stats: ContinuousMovementStats


## direction where the projectile is moving
var _direction : Vector3 = Vector3.FORWARD


## here we can setup the strategy before use
func initialize(origin: Node3D) -> void:
	# we take the origin (usually the shooting point) forward position
	_direction = origin.global_transform.basis.z.normalized()


## function responsible for handling any continuous movement like projectiles
func update_movement(delta: float, transform_to_move: Transform3D) -> Transform3D:
	transform_to_move.origin += _direction * continuous_movement_stats.max_speed * delta
	return transform_to_move
