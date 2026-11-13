class_name GameResultController
extends Node

@export_group("Events")
## event emitted when the base is destroyed
@export var _on_base_destroyed : BaseEvent
## event emitted when the player runs out of lives
@export var _on_player_out_of_lives : BaseEvent
## event emitted once there are no more enemies to spawn
@export var _on_all_spawns_finished : BaseEvent
## event emitted whenever the alive enemies count changes, with the current count as context
@export var _on_enemy_count_changed : BaseEvent
## event emitted once every spawn is done and no enemies are left alive and its prompt ended, the scene manager loads what comes next
@export var _on_victory : BaseEvent
## event emitted once the level is lost and its prompt ended, the scene manager loads what comes next
@export var _on_defeat : BaseEvent

@export_group("References")
## text shown for a while once the level is won; the victory is announced when it ends
@export var _victory_prompt : LevelPrompt
## text shown for a while once the level is lost; the defeat is announced when it ends
@export var _defeat_prompt : LevelPrompt
## the level nodes that freeze while the result prompt is shown (tanks, projectiles, power-ups): nothing moves after the outcome
@export var _gameplay_nodes : Array[Node]
## the game progress, saved the moment the outcome is decided (before the prompt, so quitting during it changes nothing)
@export var _game_progress : GameProgressResource

## true once there are no more enemies to spawn
var _are_all_spawns_finished : bool = false
## true once this level reached victory or defeat, so a second outcome in the same frame is ignored
var _is_level_resolved : bool = false

## last known amount of alive enemies
var _enemies_alive_count : int = 0:
	set(new_value):
		# we prevent negative counts
		_enemies_alive_count = maxi(new_value, 0)


## we subscribe to the different signals that we need to be aware of and notify
func _ready() -> void:
	_on_base_destroyed.subscribe(_on_base_destroyed_handler, tree_exited)
	_on_player_out_of_lives.subscribe(_on_player_out_of_lives_handler, tree_exited)
	_on_all_spawns_finished.subscribe(_on_all_spawns_finished_handler, tree_exited)
	_on_enemy_count_changed.subscribe(_on_enemy_count_changed_handler, tree_exited)


## the level is won once every spawn is done and no enemies are left alive
func _check_victory() -> void:
	# the guard of the outcome must also cover the save, so the level is checked here first
	if _are_all_spawns_finished and _enemies_alive_count == 0 and not _is_level_resolved:
		# the next game level and the tank level reached are saved right away
		_game_progress.save_game_level_won()
		_emit_level_outcome_event(_on_victory, _victory_prompt)


## the level is lost: the tank goes back to its first level and that is saved right away, then the defeat is shown
func _lose_level() -> void:
	if not _is_level_resolved:
		_game_progress.reset_player_entity_level()
		_emit_level_outcome_event(_on_defeat, _defeat_prompt)


## the base ran out of health, so the level is lost
func _on_base_destroyed_handler(_event_context: Variant = null) -> void:
	_lose_level()


## the player ran out of lives, so the level is lost
func _on_player_out_of_lives_handler(_event_context: Variant = null) -> void:
	_lose_level()


## there is nothing left to spawn, so the level is won as soon as no enemies are alive
func _on_all_spawns_finished_handler(_event_context: Variant = null) -> void:
	_are_all_spawns_finished = true
	_check_victory()


## we keep the alive count so we can tell when the last enemy is gone
func _on_enemy_count_changed_handler(new_count: int) -> void:
	_enemies_alive_count = new_count
	_check_victory()


## shows the prompt of the first outcome of the level and emits it when the prompt ends; any later outcome is ignored
func _emit_level_outcome_event(level_outcome_event: BaseEvent, level_outcome_prompt: LevelPrompt) -> void:
	# we ignore any outcome after the first one, a second one can arrive in the same physics flush
	if _is_level_resolved:
		return
	# we mark it before emitting, a listener could cause another outcome synchronously
	_is_level_resolved = true
	# deferred: the outcome can arrive inside a physics callback, where bodies can't leave the physics space
	_freeze_gameplay.call_deferred()
	# the outcome is announced once its text was on screen for a while, then the scene manager decides what comes next
	level_outcome_prompt.subscribe_to_finished(level_outcome_event.emit)
	level_outcome_prompt.show_prompt()


## disables the gameplay nodes: their children stop processing and their bodies and areas leave the physics space
func _freeze_gameplay() -> void:
	for gameplay_node : Node in _gameplay_nodes:
		# the whole level is freed when the scene manager moves on, so nothing is restored
		gameplay_node.process_mode = Node.PROCESS_MODE_DISABLED
