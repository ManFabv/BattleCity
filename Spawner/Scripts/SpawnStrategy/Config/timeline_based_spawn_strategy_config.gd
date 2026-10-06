class_name TimelineBasedSpawnStrategyConfig
extends SpawnStrategyConfig

@export_group("Events")
## event we listen to in order to know when the count of spawned nodes alive changes
@export var _on_alive_count_changed : BaseEvent
## event emitted once, when the last entry of the timeline has spawned
@export var _on_all_waves_finished : BaseEvent
@export_group("References")
## the shared timer manager used to request the entry timers
@export var timer_manager : TimerManagerResource
@export_group("Config")
## maximum spawned nodes alive at the same time
@export_range(1, 20) var max_alive_count : int = 3
## entries of the level, in spawn order
@export var _spawn_entry_configs : Array[TimelineSpawnEntryConfig]


## creates the timeline based spawn strategy that uses this config's entries and capacity
func create_spawn_strategy() -> SpawnStrategyInterface:
	return TimelineBasedSpawnStrategy.new(self)


## spawn entry config for the given step of the timeline
func get_spawn_entry_config_at(index: int) -> TimelineSpawnEntryConfig:
	return _spawn_entry_configs[index]


## index of the last entry
func last_index() -> int:
	return _spawn_entry_configs.size() - 1


## listeners are notified every time the count of spawned nodes alive changes
func subscribe_to_alive_count_changed(on_alive_count_changed: Callable, owner_exited: Signal) -> void:
	# we listen to the alive count until the owner exits the tree
	_on_alive_count_changed.subscribe(on_alive_count_changed, owner_exited)


## notifies once that the last entry has spawned
func emit_all_waves_finished_event() -> void:
	# we notify whoever listens that there is nothing left to spawn
	_on_all_waves_finished.emit()
