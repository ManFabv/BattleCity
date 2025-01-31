extends InputInterface

#input action names variables
var _move_left_name : String
var _move_right_name : String
var _move_up_name : String
var _move_down_name : String
var _fire_prymary_name : String

func _ready() -> void:
	# we map the input actions according to this player id
	_move_left_name = "move_left_p1"
	_move_right_name = "move_right_p1"
	_move_up_name = "move_up_p1"
	_move_down_name = "move_down_p1"
	_fire_prymary_name = "fire_primary_p1"


## here we need to get the gamepad input and return it
func get_input_movement() -> Vector2:
	# we get the input of the keyboard
	var move_input : Vector2 = Input.get_vector(_move_left_name, _move_right_name, _move_up_name, _move_down_name)
	# we return the input value
	return move_input


# here we need to calculate where to look according to right stick
func get_look_at() -> Vector2:
	return Vector2.ZERO
