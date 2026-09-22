class_name LevelOutcomeController
extends Node

## event emitted when the base is destroyed
@export var _on_base_destroyed : BaseEvent
## event emitted when the player runs out of lives
@export var _on_player_out_of_lives : BaseEvent
## event emitted once every wave is finished and no enemies are left alive
@export var _on_victory : BaseEvent
## event emitted once the level is lost
@export var _on_defeat : BaseEvent


func _ready() -> void:
	_on_base_destroyed.subscribe(_on_base_destroyed_handler, tree_exited)
	_on_player_out_of_lives.subscribe(_on_player_out_of_lives_handler, tree_exited)
	_on_victory.subscribe(_on_victory_handler, tree_exited)


## the base ran out of health, so the level is lost
func _on_base_destroyed_handler(_event_context: Variant = null) -> void:
	_on_defeat.emit()


## the player ran out of lives, so the level is lost
func _on_player_out_of_lives_handler(_event_context: Variant = null) -> void:
	_on_defeat.emit()


## TODO: this should trigger whatever "you win" flow exists once there's a scene/UI for it
func _on_victory_handler(_event_context: Variant = null) -> void:
	pass
