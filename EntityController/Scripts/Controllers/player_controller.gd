class_name PlayerController
extends EntityControllerInterface

@export_group("Controllers")
## reference to the input manager
@export var _input_manager : InputManager


func get_move_direction() -> Vector3:
	# we get the move axis from the input manager
	var move_input : Vector2 = _input_manager.get_input_movement()
	# we normalize the input
	move_input = move_input.normalized()
	# we convert 2D input to 3D movement
	var move_direction : Vector3 = Vector3(move_input.x, 0, move_input.y)
	# we return the wanted move direction
	return move_direction


func get_look_at_angle() -> float:
	# we get the position where we have to look at
	var look_at_input : Vector2 = _input_manager.get_look_at()
	# the input's y is the world's z, so the yaw comes straight from the 2D input
	return atan2(-look_at_input.x, -look_at_input.y)


func is_shot_pressed() -> bool:
	return _input_manager.is_shot_pressed()
