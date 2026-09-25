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
	_on_defeat.subscribe(_on_defeat_handler, tree_exited)


## the base ran out of health, so the level is lost
func _on_base_destroyed_handler(_event_context: Variant = null) -> void:
	_on_defeat.emit()


## the player ran out of lives, so the level is lost
func _on_player_out_of_lives_handler(_event_context: Variant = null) -> void:
	_on_defeat.emit()


## every wave is cleared and no enemies remain: stop gameplay and restart.
## TODO: replace this reload with the levels system / level manager once it exists,
## so a victory advances to the next level instead of restarting the current one
func _on_victory_handler(_event_context: Variant = null) -> void:
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()


## the level is lost (base destroyed or player out of lives): restart the
## current level from scratch so enemy counters, spawners, power-ups and
## player lives all start clean. There is no separate game-over flow yet
## (out of scope, see #315), so any defeat condition just restarts
## TODO: replace this reload with the levels system / level manager once it exists
func _on_defeat_handler(_event_context: Variant = null) -> void:
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()
