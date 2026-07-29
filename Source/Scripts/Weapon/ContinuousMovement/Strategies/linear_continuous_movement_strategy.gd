extends ContinuousMovementStrategy
class_name LinearContinuousMovementStrategy

@export_range(0.0, 100.0) var speed : float = 10.0:
	get():
		return speed
	set(new_value):
		speed = new_value


## direction where the projectile is moving
var _direction : Vector3 = Vector3.FORWARD


## here we can setup the strategy before use
func initialize(origin: Node3D) -> void:
	# we take the origin (usually the shooting point) forward position
	_direction = origin.global_transform.basis.z.normalized()


## function responsible for handling any continuous movement like projectiles
func update_continuous_movement(delta: float, transform_to_move: Transform3D) -> Transform3D:
	transform_to_move.origin += _direction * speed * delta
	return transform_to_move
