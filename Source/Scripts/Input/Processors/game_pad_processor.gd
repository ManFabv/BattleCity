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
var _open_ui_menu_name : String = "open_ui_menu"


func _ready() -> void:
	# we map the input actions
	_move_left_name = "move_left_p1"
	_move_right_name = "move_right_p1"
	_move_up_name = "move_up_p1"
	_move_down_name = "move_down_p1"
	_fire_primary_name = "fire_primary_p1"
	# we map the look at input actions
	_look_left_name = "look_down_p1"
	_look_right_name = "look_down_p1"
	_look_up_name = "look_down_p1"
	_look_down_name = "look_down_p1"


## here we need to get the gamepad input and return it
func get_input_movement() -> Vector2:
	# we get the input of the keyboard
	var move_input : Vector2 = Input.get_vector(_move_left_name, _move_right_name, _move_up_name, _move_down_name)
	# we return the input value
	return move_input


# here we need to calculate where to look according to right stick
func get_look_at() -> Vector2:
	# we get the input of the right stick of the gamepad
	var move_input : Vector2 = Input.get_vector(_look_left_name, _look_right_name, _look_up_name, _look_down_name)
	# we return the input value
	return move_input


func is_open_menu_pressed() -> bool:
	return Input.is_action_just_pressed(_open_ui_menu_name)
