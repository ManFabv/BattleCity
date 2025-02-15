class_name PlayerController
extends EntityController

var _owner : ControllableEntity

#input manager
var _input_manager : InputManager:
	set(new_input_manager):
		#we assign the new input manager
		_input_manager = new_input_manager


func configure(new_input_manager : InputManager, new_owner : ControllableEntity) -> void:
	_input_manager = new_input_manager
	_owner = new_owner


func on_input_type_changed() -> void:
	print("INPUT CHANGED")


func on_menu_opened() -> void:
	print("MENU OPENED")


func get_move_direction() -> Vector3:
	# this can be processed on another class by AI
	var move_input : Vector2 = _process_move_input()
	# we normalize the input
	move_input = move_input.normalized()
	# we convert 2D input to 3D movement
	var move_direction : Vector3 = Vector3(move_input.x, 0, move_input.y)
	# we return the wanted move direction
	return move_direction


func get_look_at_angle() -> float:
	# we get the position where we have to look at
	var look_at_input : Vector2 = _process_look_at_input()
	# we convert the input to 3D to be able to move the player in the world
	var world_look_at : Vector3 = Vector3(look_at_input.x, _owner.global_position.y, look_at_input.y)
	var desired_look_at_angle : float = atan2(-world_look_at.x, -world_look_at.z)
	# we return the wanted angle
	return desired_look_at_angle


func _process_move_input() -> Vector2:
	return _input_manager.get_input_movement()


func _process_look_at_input() -> Vector2:
	return _input_manager.get_look_at()


func is_shot_pressed() -> bool:
	return _input_manager.is_shot_pressed()
