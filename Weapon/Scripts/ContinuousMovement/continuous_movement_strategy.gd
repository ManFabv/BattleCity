extends Node
class_name ContinuousMovementStrategy


## here we can setup the strategy before use
func initialize(_origin: Node3D) -> void:
	push_error("initialize() should be implemented on inherited")


## function responsible for calculating the movement of projectiles
func get_motion(_delta: float) -> Vector3:
	push_error("get_motion() should be implemented on inherited")
	return Vector3.ZERO
