class_name TimelineBasedSpawnStrategy
extends SpawnStrategyInterface

## the config with the capacity, the events and the timeline entries
var _timeline_based_spawn_strategy_config : TimelineBasedSpawnStrategyConfig
## the spawn points the entries refer to, indexed by their spawn_point_id
var _spawn_point_by_id : Dictionary[int, SpawnPoint] = {}
## one timer for the whole timeline, restarted with the delay of each entry once the previous one spawned
var _spawn_delay_timer : CustomTimer
## true once the delay of the next entry elapsed, it stays due until there is room for it
var _is_next_spawn_entry_waiting_over : bool = false

## spawned nodes currently alive, kept up to date by the alive count changed event
var _spawned_nodes_alive_count : int = 0:
	set(new_value):
		# we clamp the value so the count never goes below zero or above the capacity
		_spawned_nodes_alive_count = clampi(
				new_value, 
				0, 
				_timeline_based_spawn_strategy_config.max_alive_count)

## next entry to spawn; one past the last entry means the timeline is finished
var _next_spawn_entry_index : int = 0:
	set(new_value):
		# up to one past the last entry, which is how we know the timeline is finished
		_next_spawn_entry_index = clampi(
				new_value, 
				0, 
				_timeline_based_spawn_strategy_config.last_index() + 1)

## the entry the timeline is waiting for, only read while the timeline is not finished
var _next_spawn_entry_config : TimelineSpawnEntryConfig:
	get():
		return _timeline_based_spawn_strategy_config.get_spawn_entry_config_at(_next_spawn_entry_index)


## we cache the config
func _init(timeline_based_spawn_strategy_config: TimelineBasedSpawnStrategyConfig) -> void:
	# we cache the config so we can read the entries, capacity, timer manager and events later
	_timeline_based_spawn_strategy_config = timeline_based_spawn_strategy_config


## we validate the timeline and start the delay of the first entry
func configure(spawn_points: Array[SpawnPoint], owner_exited: Signal) -> void:
	# the timeline only starts when every spawn point id is unique and every entry is valid
	if _index_spawn_points_by_id(spawn_points) and _are_spawn_entries_valid():
		# a single manual timer for the whole timeline, it starts now with the delay of the first entry
		_spawn_delay_timer = _timeline_based_spawn_strategy_config.timer_manager.create_manual(
				_next_spawn_entry_config.spawn_delay_seconds, 
				_on_spawn_delay_timer_timeout,
				owner_exited,
				true)
		# we listen to the alive count so we know when there is room again
		_timeline_based_spawn_strategy_config.subscribe_to_alive_count_changed(
				_on_alive_count_changed_handler, 
				owner_exited)


## indexes the spawn points by their id, false when two of them share the same id
func _index_spawn_points_by_id(spawn_points: Array[SpawnPoint]) -> bool:
	# we index every spawn point assigned in the manager
	for spawn_point : SpawnPoint in spawn_points:
		# an empty slot left in the manager's array can't spawn anything
		if is_instance_valid(spawn_point):
			# two spawn points with the same id would make the entries ambiguous
			if _spawn_point_by_id.has(spawn_point.spawn_point_id):
				push_error("spawn point id %d is used by more than one spawn point" % spawn_point.spawn_point_id)
				return false
			# we keep the spawn point under its id
			_spawn_point_by_id[spawn_point.spawn_point_id] = spawn_point
	return true


## true when there is at least one entry and every entry has a scene and a spawn point id that exists
func _are_spawn_entries_valid() -> bool:
	# a timeline without entries never finishes, so the level could not be won
	if _timeline_based_spawn_strategy_config.last_index() < 0:
		push_error("timeline based spawn strategy needs at least one entry")
		return false
	# we check every entry
	for entry_index : int in range(_timeline_based_spawn_strategy_config.last_index() + 1):
		# we get the spawn entry config
		var spawn_entry_config : TimelineSpawnEntryConfig = _timeline_based_spawn_strategy_config.get_spawn_entry_config_at(entry_index)
		# an empty slot left in the inspector can't spawn anything
		if is_instance_valid(spawn_entry_config):
			# the entry needs a scene to spawn and a spawn point that exists
			if is_instance_valid(spawn_entry_config.scene_to_spawn) and _spawn_point_by_id.has(spawn_entry_config.spawn_point_id):
				continue
		# we report the entry that would break the timeline
		push_error("timeline entry %d is empty, has no scene or points to a spawn point id that does not exist" % entry_index)
		return false
	return true


## spawns the next entry if its delay elapsed and there is room, then starts the delay of the following one
func _try_spawn_next_entry() -> void:
	# we wait until the entry is due and there is room for it
	if not _is_next_spawn_entry_waiting_over or _spawned_nodes_alive_count >= _timeline_based_spawn_strategy_config.max_alive_count:
		return
	# we cache the entry before moving past it
	var spawn_entry_config : TimelineSpawnEntryConfig = _next_spawn_entry_config
	# we consume the entry before spawning so the state is right when the spawn events fire
	_is_next_spawn_entry_waiting_over = false
	# we move to the next entry
	_next_spawn_entry_index += 1
	# we spawn the scene of this entry at its spawn point, both validated when the timeline started
	_spawn_point_by_id[spawn_entry_config.spawn_point_id].spawn(spawn_entry_config.scene_to_spawn)
	# the last spawn finishes the timeline: we notify it once and the timer is never started again
	if _next_spawn_entry_index > _timeline_based_spawn_strategy_config.last_index():
		_timeline_based_spawn_strategy_config.emit_all_spawns_finished_event()
		return
	# the delay of the next entry counts from this spawn
	_spawn_delay_timer.start(_next_spawn_entry_config.spawn_delay_seconds)


## the delay of the next entry elapsed: it is due until there is room for it
func _on_spawn_delay_timer_timeout() -> void:
	# the next entry is waiting to spawn
	_is_next_spawn_entry_waiting_over = true
	# deferred because a manual timer stops itself right after this callback, so a start() made inside it would be lost
	_try_spawn_next_entry.call_deferred()


## we cache the new alive count and check if there is room again
func _on_alive_count_changed_handler(new_count: int) -> void:
	# we cache the new amount of spawned nodes alive
	_spawned_nodes_alive_count = new_count
	# deferred because we want to wait until this frame and timers are processed
	_try_spawn_next_entry.call_deferred()
