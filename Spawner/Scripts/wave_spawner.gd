class_name WaveSpawner
extends Node3D

## wave configuration with spawn delays and node scenes
@export var _wave_config: WaveSpawnerConfig
## event emitted when a node is spawned
@export var _on_node_spawned: BaseEvent
## the event used to request the spawn delay timer
@export var _on_timer_requested: BaseEvent

## timer handling spawn delays
var _timer_context: CustomTimerContext
## whether we are currently counting down before spawning
var _is_counting_down: bool = false


func _ready() -> void:
	# _wave_config is a shared Resource cached by path: without this, restarting
	# the level after a defeat would resume with the previous run's index
	# instead of starting the wave over
	_wave_config.reset_index()
	# we check if the wave config arrays have the same size
	if _wave_config.spawn_delays.size() != _wave_config.node_scenes.size():
		push_error("WaveSpawnerConfig arrays must have the same size")
		return
	
	# create the timer for the first spawn, but don't start it automatically
	# it will be started when allow_spawn() is called for the first time
	var first_delay: float = _wave_config.current_delay()
	_timer_context = CustomTimerContext.create_manual(first_delay, _spawn_current_node, tree_exited, false)
	_on_timer_requested.emit(_timer_context)


## request to spawn the next node, returns true if slot was reserved
func allow_spawn() -> bool:
	if _is_counting_down or _wave_config.is_finished():
		return false
	_is_counting_down = true
	# restart timer with the delay for current step
	var next_delay: float = _wave_config.current_delay()
	_timer_context.restart_requested.emit(next_delay)
	return true


## true once this spawner has already spawned every node in its wave
func is_finished() -> bool:
	return _wave_config.is_finished()


## spawn the node at current step and move to next step
func _spawn_current_node() -> void:
	# when timer fires, we're done counting down
	_is_counting_down = false
	# instantiate the node for the current step
	var node: ControllableEntity = _wave_config.current_node_scene().instantiate() as ControllableEntity
	# _on_node_spawned parents the node (NodeContainer.add_child); global_position
	# can only be set once the node is inside the tree
	_on_node_spawned.emit(node)
	node.global_position = global_position
	# advance to the next step, no wrap: the wave is done once it runs out of steps
	_wave_config.advance_index()
