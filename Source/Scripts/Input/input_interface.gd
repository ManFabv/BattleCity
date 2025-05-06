## this is only an interface for the different input
class_name InputInterface
extends Node


func get_input_movement() -> Vector2:
	push_error("get_input_movement() should be implemented on inherited classes")
	return Vector2.ZERO


func get_look_at() -> Vector2:
	push_error("get_look_at() should be implemented on inherited classes")
	return Vector2.ZERO


func is_open_menu_pressed() -> bool:
	push_error("is_open_menu_pressed() should be implemented on inherited classes")
	return false


func is_shot_pressed() -> bool:
	push_error("is_shot_pressed() should be implemented on inherited classes")
	return false


func is_shot_just_pressed() -> bool:
	push_error("is_shot_just_pressed() should be implemented on inherited classes")
	return false


func is_shot_just_released() -> bool:
	push_error("is_shot_just_released() should be implemented on inherited classes")
	return false
