extends InputInterface

## here we always return zero
func get_input_movement() -> Vector2:
	return Vector2.ZERO


# here we always return zero
func get_look_at() -> Vector2:
	return Vector2.ZERO


# we don't want to open the menu
func is_open_menu_pressed() -> bool:
	return false


# we don't need to do anything
func set_camera(new_player_camera: PlayerCamera) -> void:
	push_error("set_camera() should be implemented on inherited classes")
