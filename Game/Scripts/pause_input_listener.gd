class_name PauseInputListener
extends Node
## announces the pause input of the level; runs while paused so the same input can resume the game

## input action that toggles the pause, as StringName so the event check doesn't convert a String
const _OPEN_UI_MENU_ACTION : StringName = &"open_ui_menu"

@export_group("Events")
## event announcing that the pause input was pressed
@export var _on_pause_input_pressed : BaseEvent


## unhandled input: the GUI, such as the pause overlay buttons, gets the event before us
func _unhandled_input(event: InputEvent) -> void:
	# we only react to a fresh press of this event, never to an echo or to other events of the frame
	if event.is_action_pressed(_OPEN_UI_MENU_ACTION, false):
		# we consume the event so no other node handles it
		get_viewport().set_input_as_handled()
		# we announce the press, the listeners decide what pausing means
		_on_pause_input_pressed.emit()
