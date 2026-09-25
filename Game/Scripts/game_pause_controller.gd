class_name GamePauseController
extends Node

## event we listen to in order to know when the menu opens
@export var _on_menu_opened_event : BaseEvent


func _ready() -> void:
	_on_menu_opened_event.subscribe(_on_menu_opened_handler, tree_exited)


## toggles the scene tree's pause: pauses every pausable node (movement, AI, timers)
## if the game was running, or resumes them if it was already paused
## TODO: this only flips get_tree().paused; once we have a proper pause menu UI
## this should show/hide it instead
func _on_menu_opened_handler(_event_context: Variant = null) -> void:
	get_tree().paused = not get_tree().paused
