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
func is_shot_pressed() -> bool:
	return false


# we don't need to do anything
func is_shot_just_pressed() -> bool:
	return false


# we don't need to do anything
func is_shot_just_released() -> bool:
	return false


# we don't need to do anything
func configure(_new_player_camera: PlayerCamera, _new_player: ControllableEntity) -> void:
	pass
