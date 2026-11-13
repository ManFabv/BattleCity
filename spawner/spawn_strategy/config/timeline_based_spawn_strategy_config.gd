@tool
class_name TimelineBasedSpawnStrategyConfig
extends SpawnStrategyConfig

@export_group("Events")
## event we listen to in order to know when the count of spawned nodes alive changes
@export var _on_alive_count_changed : BaseEvent
## event emitted once, when the last entry of the timeline has spawned
@export var _on_all_spawns_finished : BaseEvent

@export_group("References")
## the shared timer manager used to request the entry timers
@export var _timer_manager : TimerManagerResource

@export_group("Config")
## maximum spawned nodes alive at the same time
@export_range(1, 20) var max_alive_count : int = 3:
	set(new_value):
		# we need room for at least one spawned node, or the timeline would never spawn
		max_alive_count = maxi(new_value, 1)
## entries of the level, in spawn order
@export var _spawn_entry_configs : Array[TimelineSpawnEntryConfig]


## creates the timeline based spawn strategy that uses this config's entries and capacity
func create_spawn_strategy() -> SpawnStrategyInterface:
	return TimelineBasedSpawnStrategy.new(self)


## the ids of the spawn points have to be unique and every entry needs a scene and an id that exists
func get_configuration_warnings(spawn_points: Array[SpawnPoint]) -> PackedStringArray:
	# we collect everything that is wrong
	var warnings : PackedStringArray = PackedStringArray()
	# the ids the entries can point to
	var spawn_point_ids : Dictionary[int, bool] = {}
	# we check every spawn point assigned in the manager
	for spawn_point : SpawnPoint in spawn_points:
		# an empty slot left in the manager's array can't spawn anything
		if is_instance_valid(spawn_point):
			# two spawn points with the same id would make the entries ambiguous
			if spawn_point_ids.has(spawn_point.spawn_point_id):
				warnings.append("spawn point id %d is used by more than one spawn point" % spawn_point.spawn_point_id)
			# we keep the id
			spawn_point_ids[spawn_point.spawn_point_id] = true
	# a timeline without entries never finishes, so the level could not be won
	if _spawn_entry_configs.is_empty():
		warnings.append("timeline based spawn strategy needs at least one entry")
	# we check every entry
	for entry_index : int in _spawn_entry_configs.size():
		# an empty slot left in the inspector can't spawn anything
		var spawn_entry_config : TimelineSpawnEntryConfig = _spawn_entry_configs[entry_index]
		# the entry needs a scene to spawn and a spawn point that exists
		if not (is_instance_valid(spawn_entry_config) and is_instance_valid(spawn_entry_config.scene_to_spawn) and spawn_point_ids.has(spawn_entry_config.spawn_point_id)):
			warnings.append("timeline entry %d is empty, has no scene or points to a spawn point id that does not exist" % entry_index)
	return warnings


## spawn entry config for the given step of the timeline
func get_spawn_entry_config_at(index: int) -> TimelineSpawnEntryConfig:
	return _spawn_entry_configs[index]


## index of the last entry
func last_index() -> int:
	return _spawn_entry_configs.size() - 1


## requests the manual timer that waits the delay of an entry, it starts right away
func create_spawn_delay_timer(delay_seconds: float, on_timeout: Callable, owner_exited: Signal) -> CustomTimer:
	return _timer_manager.create_manual(delay_seconds, on_timeout, owner_exited, true)


## listeners are notified every time the count of spawned nodes alive changes
func subscribe_to_alive_count_changed(on_alive_count_changed: Callable, owner_exited: Signal) -> void:
	# we listen to the alive count until the owner exits the tree
	_on_alive_count_changed.subscribe(on_alive_count_changed, owner_exited)


## notifies once that the last entry has spawned
func emit_all_spawns_finished_event() -> void:
	# we notify whoever listens that there is nothing left to spawn
	_on_all_spawns_finished.emit()
