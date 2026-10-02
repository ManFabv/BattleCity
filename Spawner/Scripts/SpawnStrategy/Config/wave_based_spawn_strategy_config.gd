class_name WaveBasedSpawnStrategyConfig
extends SpawnStrategyConfigInterface

@export_group("Events")
## event we listen to in order to know when the count of spawned nodes alive changes
@export var _on_alive_count_changed : BaseEvent
## event emitted once, when every spawn point has spawned all its wave
@export var _on_all_waves_finished : BaseEvent
@export_group("References")
## the shared timer manager used to request the spawn delay timers
@export var timer_manager : TimerManagerResource
@export_group("Config")
## maximum spawned nodes alive at the same time
@export_range(1, 20) var max_alive_count : int = 3


## creates the wave based spawn strategy that uses this config's capacity
func create_spawn_strategy() -> SpawnStrategyInterface:
	return WaveBasedSpawnStrategy.new(self)


## listeners are notified every time the count of spawned nodes alive changes
func subscribe_to_alive_count_changed(on_alive_count_changed: Callable, owner_exited: Signal) -> void:
	# we listen to the alive count until the owner exits the tree
	_on_alive_count_changed.subscribe(on_alive_count_changed, owner_exited)


## notifies once that every spawn point has spawned all its wave
func emit_all_waves_finished_event() -> void:
	# we notify whoever listens that every wave is finished
	_on_all_waves_finished.emit()
