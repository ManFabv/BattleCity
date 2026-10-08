class_name EntityControllerInterface
extends Node

@export_group("References")
## who is the AI entity that we want to move
@export var owner_controllable_entity : ControllableEntity


func get_move_direction() -> Vector3:
	push_error("get_move_direction() should be implemented on inherited classes")
	return Vector3.ZERO


func get_look_at_angle() -> float:
	push_error("get_look_at_angle() should be implemented on inherited classes")
	return 0


func is_shot_pressed() -> bool:
	push_error("is_shot_pressed() should be implemented on inherited classes")
	return false
