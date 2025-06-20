class_name GamePadProcessor
extends InputInterface

#input action names variables
var _move_left_name : String
var _move_right_name : String
var _move_up_name : String
var _move_down_name : String
var _fire_primary_name : String
#input action look at name variables
var _look_left_name : String
var _look_right_name : String
var _look_up_name : String
var _look_down_name : String
#input action for open menu
var _open_ui_menu_name : String

#when the player is not moving the right stick, we keep looking at the same point
var _last_point_position : Vector2 = Vector2.ZERO


func _ready() -> void:
	# we map the input actions
	_move_left_name = "move_left_p1"
	_move_right_name = "move_right_p1"
	_move_up_name = "move_up_p1"
	_move_down_name = "move_down_p1"
	_fire_primary_name = "fire_primary_p1"
	# we map the look at input actions
	_look_left_name = "look_left_p1"
	_look_right_name = "look_rigth_p1"
	_look_up_name = "look_up_p1"
	_look_down_name = "look_down_p1"
	# we map the open UI menu
	_open_ui_menu_name = "open_ui_menu"


# called when we are going to start using this input
func enter_input_type() -> void:
	pass #TODO: here we can change cursor GUI


# called when we are going to stop using this input and change to another
func exit_input_type() -> void:
	pass #TODO: here we can change cursor GUI


## here we need to get the gamepad input and return it
func get_input_movement() -> Vector2:
	# we get the input of the keyboard
	var move_input : Vector2 = Input.get_vector(
		_move_left_name, _move_right_name, _move_up_name, _move_down_name
		)
	# we return the input value
	return move_input


# here we need to calculate where to look according to right stick
func get_look_at() -> Vector2:
	# we get the input of the right stick of the gamepad
	var move_input : Vector2 = Input.get_vector(
		_look_left_name, _look_right_name, _look_up_name, _look_down_name
		)
	# if we have some input, we cache it
	if move_input != Vector2.ZERO:
		_last_point_position = move_input
	# we return the last input value
	return _last_point_position


func is_open_menu_pressed() -> bool:
	return Input.is_action_just_pressed(_open_ui_menu_name)


func is_shot_pressed() -> bool:
	return Input.is_action_pressed(_fire_primary_name)


func is_shot_just_pressed() -> bool:
	return Input.is_action_just_pressed(_fire_primary_name)


func is_shot_just_released() -> bool:
	return Input.is_action_just_released(_fire_primary_name)
