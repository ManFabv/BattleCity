class_name KeyboardAndMouseProcessor
extends InputInterface

#input action names variables
var _move_left_name : String
var _move_right_name : String
var _move_up_name : String
var _move_down_name : String
var _fire_primary_name : String
#input action for open menu
var _open_ui_menu_name : String

@export_group("References")
## player camera
@export var _player_camera : PlayerCamera
## player
@export var _player : ControllableEntity


func _ready() -> void:
	# we map the input actions according to this player id
	_move_left_name = "move_left_p1"
	_move_right_name = "move_right_p1"
	_move_up_name = "move_up_p1"
	_move_down_name = "move_down_p1"
	_fire_primary_name = "fire_primary_p1"
	# we map the open UI menu
	_open_ui_menu_name = "open_ui_menu"


# called when we are going to start using this input
func enter_input_type() -> void:
	pass #TODO: here we can change cursor GUI


# called when we are going to stop using this input and change to another
func exit_input_type() -> void:
	pass #TODO: here we can change cursor GUI


# here we get the input according to their input axis
func get_input_movement() -> Vector2:
	# we get the input of the keyboard
	var move_input : Vector2 = Input.get_vector(
		_move_left_name, _move_right_name, _move_up_name, _move_down_name
		)
	# we return the input value
	return move_input


# here we need to calculate where to look according to mouse position
func get_look_at() -> Vector2:
	# we get the mouse position in viewport coordinates
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	# through the camera we convert the mouse position from 2D to 3D
	var world_pos : Vector3 = _player_camera.get_world_position_from_point(mouse_position)
	# we convert it relative to the player
	world_pos -= _player.global_position
	# we return the converted input
	return Vector2(world_pos.x, world_pos.z)


# we check if the player wants to open the menu
func is_open_menu_pressed() -> bool:
	return Input.is_action_just_pressed(_open_ui_menu_name)


func is_shot_pressed() -> bool:
	return Input.is_action_pressed(_fire_primary_name)


func is_shot_just_pressed() -> bool:
	return Input.is_action_just_pressed(_fire_primary_name)


func is_shot_just_released() -> bool:
	return Input.is_action_just_released(_fire_primary_name)
