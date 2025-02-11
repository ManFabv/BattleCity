## this is only an interface for the different input
class_name InputInterface
extends Node


func get_input_movement() -> Vector2:
	return Vector2.ZERO


func get_look_at() -> Vector2:
	return Vector2.ZERO


func is_open_menu_pressed() -> bool:
	return false


func is_shot_pressed() -> bool:
	return false


func setup_before_enter_tree(_new_player_camera: PlayerCamera, _new_player: Player) -> void:
	push_error("setup_before_enter_tree() should be implemented on inherited classes")
