class_name GamePadProcessor
extends InputInterface

## right stick actions, only the gamepad aims with them
const _LOOK_LEFT_ACTION : StringName = &"look_left_p1"
const _LOOK_RIGHT_ACTION : StringName = &"look_right_p1"
const _LOOK_UP_ACTION : StringName = &"look_up_p1"
const _LOOK_DOWN_ACTION : StringName = &"look_down_p1"

## when the player is not moving the right stick, we keep looking at the same point
var _last_point_position : Vector2 = Vector2.ZERO


## called when we are going to start using this input
func enter_input_type() -> void:
	pass # TODO: show the gamepad aim reticle


## called when we are going to stop using this input and change to another
func exit_input_type() -> void:
	pass # TODO: hide the gamepad aim reticle


## here we need to calculate where to look according to right stick
func get_look_at() -> Vector2:
	# we get the input of the right stick of the gamepad
	var stick_input : Vector2 = Input.get_vector(_LOOK_LEFT_ACTION, _LOOK_RIGHT_ACTION, _LOOK_UP_ACTION, _LOOK_DOWN_ACTION)
	# if we have some input, we cache it
	if stick_input != Vector2.ZERO:
		_last_point_position = stick_input
	# we return the last input value
	return _last_point_position
