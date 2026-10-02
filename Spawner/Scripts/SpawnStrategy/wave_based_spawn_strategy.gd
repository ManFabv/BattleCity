class_name WaveBasedSpawnStrategy
extends SpawnStrategyInterface

## the config with the capacity and the events
var _wave_based_spawn_strategy_config : WaveBasedSpawnStrategyConfig
## the wave spawn points this strategy runs, each one with its own wave runner
var _wave_spawn_points : Array[WaveSpawnPoint] = []
## one runner per spawn point, in the same order
var _wave_runners : Array[WaveRunner] = []
## spawned nodes currently alive, kept up to date by the alive count changed event
var _alive_count : int = 0:
	set(new_value):
		# we clamp the value so the count never goes below zero or above the capacity
		_alive_count = clampi(new_value, 0, _wave_based_spawn_strategy_config.max_alive_count)
## nodes that were allowed to spawn but have not spawned yet.
## needed so we don't over-notify spawn points while a countdown is running
var _reserved_spawn_count : int = 0:
	set(new_value):
		# we clamp the value so the reservations never go below zero or above the capacity
		_reserved_spawn_count = clampi(new_value, 0, _wave_based_spawn_strategy_config.max_alive_count)


## we cache the config
func _init(config: WaveBasedSpawnStrategyConfig) -> void:
	# we cache the config so we can read the capacity, timer manager and events later
	_wave_based_spawn_strategy_config = config


func configure(spawn_points: Array[SpawnPointInterface], owner_exited: Signal) -> void:
	# we create one wave runner per wave spawn point, in the same order
	for spawn_point : SpawnPointInterface in spawn_points:
		# this strategy runs on WaveSpawnPoints, each one holds the wave it runs
		var wave_spawn_point : WaveSpawnPoint = spawn_point as WaveSpawnPoint
		# only a wave spawn point has a wave to run
		if is_instance_valid(wave_spawn_point):
			# the index this spawn point and its runner take, so both arrays stay aligned
			var index : int = _wave_spawn_points.size()
			# we cache the spawn point so its runner can spawn on it
			_wave_spawn_points.append(wave_spawn_point)
			# we create the runner, its timer calls _spawn_next with this spawn point index
			_wave_runners.append(WaveRunner.new(wave_spawn_point.wave_spawns, _wave_based_spawn_strategy_config.timer_manager, _spawn_next.bind(index), owner_exited))
	# we listen to the alive count so we know when there is room to spawn again
	_wave_based_spawn_strategy_config.subscribe_to_alive_count_changed(_on_alive_count_changed_handler, owner_exited)
	# we start the first spawns while there is room
	_notify_spawn_points_if_room()


## spawns the next node of the given spawn point: it just used the slot that was reserved for it
func _spawn_next(index: int) -> void:
	# the runner advances before the spawn point emits its event
	_wave_spawn_points[index].spawn(_wave_runners[index].consume_current_scene())
	# the reserved slot is now taken by the spawned node
	_reserved_spawn_count -= 1
	# we check if this was the last spawn of every wave
	_check_all_waves_finished()


func _on_alive_count_changed_handler(new_count: int) -> void:
	# we cache the new amount of spawned nodes alive
	_alive_count = new_count
	# deferred because inside a spawn timer callback that timer still reports running, so its runner would reject the request
	_notify_spawn_points_if_room.call_deferred()


## notifies only as many spawn points as there is real room for.
## each accepted notification reserves a slot, so two spawn points
## can't both fill the same last free slot
func _notify_spawn_points_if_room() -> void:
	# we offer the free room to each wave runner in order
	for wave_runner : WaveRunner in _wave_runners:
		# free room is the capacity minus the alive nodes and the ones already on their way
		var available_room : int = _wave_based_spawn_strategy_config.max_alive_count - _alive_count - _reserved_spawn_count
		# if there is no room left we stop notifying
		if available_room <= 0:
			return
		# if the runner accepts, its next spawn takes one slot
		if wave_runner.allow_spawn():
			_reserved_spawn_count += 1


## notifies once that there is nothing left to spawn, whoever listens decides what that means
func _check_all_waves_finished() -> void:
	# we look for any wave runner that still has spawns left
	for wave_runner : WaveRunner in _wave_runners:
		# if one wave is still running, we are not finished yet
		if not wave_runner.is_last_node_spawned():
			return
	# every wave is finished, so we notify it
	_wave_based_spawn_strategy_config.emit_all_waves_finished_event()
