class_name GamePauseController
extends Node

@export_group("Events")
## event we listen to in order to know when the pause input was pressed
@export var _on_pause_input_pressed : BaseEvent


## we listen to the pause input
func _ready() -> void:
	_on_pause_input_pressed.subscribe(_on_pause_input_pressed_handler, tree_exited)


## toggles the tree pause, which stops every pausable node (movement, AI, timers)
## TODO: show and hide the pause menu instead of only toggling the pause
func _on_pause_input_pressed_handler(_event_context: Variant = null) -> void:
	get_tree().paused = not get_tree().paused
