class_name InputInterface
extends Node
## base of the input processors; the InputMap merges every device, so only the aim differs

## input actions shared by every controller, as StringName so Input doesn't convert a String on every call
const _MOVE_LEFT_ACTION : StringName = &"move_left_p1"
const _MOVE_RIGHT_ACTION : StringName = &"move_right_p1"
const _MOVE_UP_ACTION : StringName = &"move_up_p1"
const _MOVE_DOWN_ACTION : StringName = &"move_down_p1"
const _FIRE_PRIMARY_ACTION : StringName = &"fire_primary_p1"
const _OPEN_UI_MENU_ACTION : StringName = &"open_ui_menu"


## called when we are going to start using this input
func enter_input_type() -> void:
	push_error("enter_input_type() should be implemented on inherited classes")


## called when we are going to stop using this input and change to another
func exit_input_type() -> void:
	push_error("exit_input_type() should be implemented on inherited classes")


## the move axis, the same actions for every controller
func get_input_movement() -> Vector2:
	return Input.get_vector(_MOVE_LEFT_ACTION, _MOVE_RIGHT_ACTION, _MOVE_UP_ACTION, _MOVE_DOWN_ACTION)


## where to look, each controller aims in its own way
func get_look_at() -> Vector2:
	push_error("get_look_at() should be implemented on inherited classes")
	return Vector2.ZERO


## we check if the player wants to open the menu
func is_open_menu_pressed() -> bool:
	return Input.is_action_just_pressed(_OPEN_UI_MENU_ACTION)


## true while the shoot input is held
func is_shot_pressed() -> bool:
	return Input.is_action_pressed(_FIRE_PRIMARY_ACTION)
