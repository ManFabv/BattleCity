class_name GamePauseController
extends Node

## event we listen to in order to know when the menu opens
@export var _on_menu_opened_event : BaseEvent


func _ready() -> void:
	_on_menu_opened_event.subscribe(_on_menu_opened_handler, tree_exited)


## pauses the scene tree so every pausable node (movement, AI, timers) stops
func _on_menu_opened_handler(_event_context: Variant = null) -> void:
	get_tree().paused = true
