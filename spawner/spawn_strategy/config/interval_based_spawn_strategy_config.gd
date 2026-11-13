@tool
class_name IntervalBasedSpawnStrategyConfig
extends SpawnStrategyConfig

@export_group("References")
## the shared timer manager used to request the interval timer
@export var _timer_manager : TimerManagerResource

@export_group("Config")
## the scenes of this level, one is picked at random on every spawn
@export var _scenes_to_spawn : Array[PackedScene]
## seconds between two spawns, the first one included
@export_range(0.5, 120.0) var spawn_interval_seconds : float = 8.0:
	set(new_value):
		# a zero interval would spawn on every frame
		spawn_interval_seconds = maxf(new_value, 0.1)
## maximum spawned nodes alive at the same time; a spawn is skipped while it is reached or no spawn point is free
@export_range(1, 20) var max_alive_count : int = 2:
	set(new_value):
		# we need room for at least one spawned node, or nothing would ever spawn
		max_alive_count = maxi(new_value, 1)


## creates the interval based spawn strategy that uses this config's scenes, interval and capacity
func create_spawn_strategy() -> SpawnStrategyInterface:
	return IntervalBasedSpawnStrategy.new(self)


## it needs at least one scene, no empty scene slot and at least one spawn point
func get_configuration_warnings(spawn_points: Array[SpawnPoint]) -> PackedStringArray:
	# we collect everything that is wrong
	var warnings : PackedStringArray = PackedStringArray()
	# without scenes there is nothing to pick
	if _scenes_to_spawn.is_empty():
		warnings.append("interval based spawn strategy needs at least one scene to spawn")
	# an empty slot would be picked at random some day
	if _scenes_to_spawn.has(null):
		warnings.append("interval based spawn strategy has an empty scene slot")
	# without spawn points there is nowhere to spawn
	if spawn_points.is_empty():
		warnings.append("interval based spawn strategy needs at least one spawn point")
	return warnings


## one of the scenes of this level at random, the warnings validated that there is one
func pick_random_scene() -> PackedScene:
	return _scenes_to_spawn.pick_random()


## requests the loop timer that ticks every interval; a loop because a manual timer stops itself after its callback
func create_interval_timer(on_timeout: Callable, owner_exited: Signal) -> CustomTimer:
	return _timer_manager.create_loop(spawn_interval_seconds, on_timeout, owner_exited)
