extends Node3D
class_name ContinuousMovementStrategy


## here we can setup the strategy before use
func initialize(_origin: Node3D) -> void:
	push_error("initialize() should be implemented on inherited")


## function responsible for handling any continuous movement like projectiles
func update_continuous_movement(_delta: float, _transform_to_move: Transform3D) -> Transform3D:
	push_error("update_continuous_movement should be implemented on inherited")
	return _transform_to_move
