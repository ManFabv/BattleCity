class_name WaveSpawner
extends Node3D

## wave configuration with the spawns (delay and node scene) to run
@export var _wave_config: WaveSpawnerConfig
## event emitted when a node is spawned
@export var _on_node_spawned: BaseEvent
## the shared timer manager used to request the spawn delay timer
@export var _timer_manager: TimerManagerResource

## timer handling spawn delays
var _timer: CustomTimer
## current spawn in the wave; once it passes the last spawn the wave is finished
var _current_index: int = 0


func _ready() -> void:
	# create the timer for the first spawn, but don't start it automatically
	# it will be started when allow_spawn() is called for the first time
	var first_delay: float = _wave_config.spawn_at(_current_index).spawn_delay
	_timer = _timer_manager.create_manual(first_delay, _spawn_current_node, tree_exited, false)


## request to spawn the next node, returns true if slot was reserved
func allow_spawn() -> bool:
	if _timer.is_running() or is_finished():
		return false
	# restart timer with the delay for current step
	_timer.start(_wave_config.spawn_at(_current_index).spawn_delay)
	return true


## true once this spawner has already spawned every node in its wave
func is_finished() -> bool:
	return _current_index > _wave_config.last_index()


## spawn the node at current step and move to next step
func _spawn_current_node() -> void:
	# instantiate the node for the current step
	var node: ControllableEntity = _wave_config.spawn_at(_current_index).node_scene.instantiate() as ControllableEntity
	# advance to the next step before emitting, no wrap: the wave is done once it runs out of steps
	_current_index += 1
	# _on_node_spawned parents the node (NodeContainer.add_child); global_position
	# can only be set once the node is inside the tree
	_on_node_spawned.emit(node)
	node.global_position = global_position
