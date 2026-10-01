class_name WaveRunner
extends RefCounted

## spawns of the wave to run
var _wave_spawns : WaveSpawns
## timer handling spawn delays
var _timer : CustomTimer
## current spawn in the wave; once it passes the last spawn the wave is finished
var _current_spawn_index : int = 0:
	set(new_value):
		# up to one past the last spawn, which is how is_last_node_spawned() knows the wave is finished
		_current_spawn_index = clampi(new_value, 0, _wave_spawns.last_index() + 1)

## the current spawn config shorthand access
var _current_spawn_config : WaveSpawnConfig:
	get():
		return _wave_spawns.get_spawn_config_at(_current_spawn_index)


## create the timer for the first spawn, but don't start it automatically
## it will be started when allow_spawn() is called for the first time
func _init(wave_spawns: WaveSpawns, timer_manager: TimerManagerResource, on_timeout: Callable, owner_exited: Signal) -> void:
	# we cache the config
	_wave_spawns = wave_spawns
	_timer = timer_manager.create_manual(_current_spawn_config.spawn_delay, on_timeout, owner_exited, false)


## request to spawn the next node, returns true if slot was reserved
func allow_spawn() -> bool:
	# if it's not ready to spawn
	if _timer.is_running() or is_last_node_spawned():
		return false
	# restart timer with the delay for current step
	_timer.start(_current_spawn_config.spawn_delay)
	return true


## scene_to_spawn of the current step, and move to next step: no wrap, the wave is done once it runs out of steps
func consume_current_scene() -> PackedScene:
	# we get the scene_to_spawn from the config
	var scene : PackedScene = _current_spawn_config.scene_to_spawn
	# we move to the next spawn of the wave
	_current_spawn_index += 1
	# we return the cached scene_to_spawn
	return scene


## true once this wave has already spawned every node
func is_last_node_spawned() -> bool:
	return _current_spawn_index > _wave_spawns.last_index()
