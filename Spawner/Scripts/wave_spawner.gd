class_name WaveSpawner
extends Node3D

## wave configuration with spawn delays and node scenes
@export var _wave_config: WaveSpawnerConfig
## event emitted when a node is spawned
@export var _on_node_spawned: BaseEvent

## current step in the wave
var _current_step: int = 0
## timer handling spawn delays
var _timer_context: TimerContext
## whether we are currently counting down before spawning
var _is_counting_down: bool = false


func _ready() -> void:
	# we check if the wave config arrays have the same size
	if _wave_config.spawn_delays.size() != _wave_config.node_scenes.size():
		push_error("WaveSpawnerConfig arrays must have the same size")
		return
	
	# create and start the timer for the first spawn
	var first_delay: float = _wave_config.spawn_delays[_current_step]
	_timer_context = TimerContext.create_manual(first_delay, _spawn_current_node, tree_exited)
	TimerContext.request(_timer_context)


## request to spawn the next node, returns true if slot was reserved
func allow_spawn() -> bool:
	if _is_counting_down:
		return false
	_is_counting_down = true
	# restart timer with the delay for current step
	var next_delay: float = _wave_config.spawn_delays[_current_step]
	_timer_context.restart_requested.emit(next_delay)
	return true


## spawn the node at current step and move to next step
func _spawn_current_node() -> void:
	# when timer fires, we're done counting down
	_is_counting_down = false
	# instantiate the node for the current step
	var node_scene: PackedScene = _wave_config.node_scenes[_current_step]
	var node: ControllableEntity = node_scene.instantiate() as ControllableEntity
	_on_node_spawned.emit(node)
	# position the node at the spawner location
	node.global_position = global_position
	# advance to the next step (looping back to 0)
	_current_step = (_current_step + 1) % _wave_config.node_scenes.size()
