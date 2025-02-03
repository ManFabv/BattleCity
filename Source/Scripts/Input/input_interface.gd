## this is only an interface for the different input
class_name InputInterface
extends Node


func get_input_movement() -> Vector2:
	return Vector2.ZERO


func get_look_at() -> Vector2:
	return Vector2.ZERO


func is_open_menu_pressed() -> bool:
	return false


func set_camera(new_player_camera: PlayerCamera) -> void:
	push_error("set_camera() should be implemented on inherited classes")


func set_player(new_player: Player) -> void:
	push_error("set_player() should be implemented on inherited classes")
