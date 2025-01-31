extends InputInterface

#input action names variables
var move_left_name : String
var move_right_name : String
var move_up_name : String
var move_down_name : String
var fire_prymary_name : String

func _ready() -> void:
	# we map the input actions according to this player id
	move_left_name = "move_left_p1"
	move_right_name = "move_right_p1"
	move_up_name = "move_up_p1"
	move_down_name = "move_down_p1"
	fire_prymary_name = "fire_primary_p1"


# here we get the input according to their input axis
func get_input_movement() -> Vector2:
	# we get the input of the keyboard
	var move_input = Input.get_vector(move_left_name, move_right_name, move_up_name, move_down_name)
	# we return the input value
	return move_input


# here we need to calculate where to look according to mouse position
func get_look_at() -> Vector2:
	return Vector2.ZERO
