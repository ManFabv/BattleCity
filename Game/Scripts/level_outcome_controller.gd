class_name LevelOutcomeController
extends Node

## event emitted when the base is destroyed
@export var _on_base_destroyed : BaseEvent
## event emitted once the level is lost
@export var _on_defeat : BaseEvent


func _ready() -> void:
	_on_base_destroyed.subscribe(_on_base_destroyed_handler, tree_exited)
	# TODO: wire player defeat once the lives/respawn system exists (see GitHub issue)


## the base ran out of health, so the level is lost
func _on_base_destroyed_handler(_event_context: Variant = null) -> void:
	_on_defeat.emit()
