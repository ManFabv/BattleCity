class_name EntityControllerInterface
extends Node

@export_group("References")
## the entity this controller drives, player or AI
@export var owner_controllable_entity : ControllableEntity


## the direction the entity wants to move, each controller decides it its own way
func get_move_direction() -> Vector3:
	push_error("get_move_direction() should be implemented on inherited classes")
	return Vector3.ZERO


## the yaw the entity wants to look at, each controller decides it its own way
func get_look_at_angle() -> float:
	push_error("get_look_at_angle() should be implemented on inherited classes")
	return 0


## true while the entity wants to shoot, each controller decides it its own way
func is_shot_pressed() -> bool:
	push_error("is_shot_pressed() should be implemented on inherited classes")
	return false
