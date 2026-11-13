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
## event emitted once every spawn is done and no enemies are left alive, the scene manager loads what comes next
@export var _on_victory : BaseEvent
## event emitted once the level is lost, the scene manager loads what comes next
@export var _on_defeat : BaseEvent

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
	if _are_all_spawns_finished and _enemies_alive_count == 0:
		_emit_level_outcome_event(_on_victory)


## the base ran out of health, so the level is lost
func _on_base_destroyed_handler(_event_context: Variant = null) -> void:
	_emit_level_outcome_event(_on_defeat)


## the player ran out of lives, so the level is lost
func _on_player_out_of_lives_handler(_event_context: Variant = null) -> void:
	_emit_level_outcome_event(_on_defeat)


## there is nothing left to spawn, so the level is won as soon as no enemies are alive
func _on_all_spawns_finished_handler(_event_context: Variant = null) -> void:
	_are_all_spawns_finished = true
	_check_victory()


## we keep the alive count so we can tell when the last enemy is gone
func _on_enemy_count_changed_handler(new_count: int) -> void:
	_enemies_alive_count = new_count
	_check_victory()


## emits the first outcome of the level and ignores any later outcome
func _emit_level_outcome_event(level_outcome_event: BaseEvent) -> void:
	# we ignore any outcome after the first one, a second one can arrive in the same physics flush
	if _is_level_resolved:
		return
	# we mark it before emitting, a listener could cause another outcome synchronously
	_is_level_resolved = true
	# we notify the outcome, the scene manager decides what comes next
	level_outcome_event.emit()
