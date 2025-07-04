class_name EntityController
extends Node

@export_group("References")
## who is the AI entity that we want to move
@export var owner_controllable_entity : ControllableEntity:
	set(new_value):
		owner_controllable_entity = new_value
	get():
		return owner_controllable_entity


func get_move_direction() -> Vector3:
	push_error("get_move_direction() should be implemented on inherited classes")
	return Vector3.ZERO


func get_look_at_angle() -> float:
	push_error("get_look_at_angle() should be implemented on inherited classes")
	return 0


func is_shot_pressed() -> bool:
	push_error("is_shot_pressed() should be implemented on inherited classes")
	return false


func on_input_type_changed() -> void:
	push_error("on_input_type_changed() should be implemented on inherited classes")


func on_menu_opened() -> void:
	push_error("on_menu_opened() should be implemented on inherited classes")
