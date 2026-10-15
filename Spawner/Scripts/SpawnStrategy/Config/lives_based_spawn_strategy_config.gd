@tool
class_name LivesBasedSpawnStrategyConfig
extends SpawnStrategyConfig

@export_group("Events")
## emitted when there are no lives left
@export var _on_out_of_lives : BaseEvent
@export_group("References")
## the shared timer manager used to request the respawn delay timer
@export var timer_manager : TimerManagerResource
## the scene_to_spawn to instantiate, one instance per life
@export var scene_to_spawn : PackedScene
@export_group("Config")
## how many lives there are at the start
@export_range(1, 10) var starting_lives : int = 3:
	set(new_value):
		# the first life always spawns, so we need at least one
		starting_lives = maxi(new_value, 1)
## how long to wait after death before spawning the next life
@export_range(0.1, 10.0) var respawn_delay : float = 2.0:
	set(new_value):
		# we prevent negative delays
		respawn_delay = maxf(new_value, 0.0)


## creates the lives based spawn strategy that uses this config's lives and delay
func create_spawn_strategy() -> SpawnStrategyInterface:
	return LivesBasedSpawnStrategy.new(self)


## every life spawns at the same place, so it needs a scene and exactly one spawn point
func get_configuration_warnings(spawn_points: Array[SpawnPoint]) -> PackedStringArray:
	# we collect everything that is wrong
	var warnings : PackedStringArray = PackedStringArray()
	# without a scene there is nothing to spawn
	if not is_instance_valid(scene_to_spawn):
		warnings.append("lives based spawn strategy needs a scene to spawn")
	# with more than one spawn point we can't know where to respawn
	if spawn_points.size() != 1:
		warnings.append("lives based spawn strategy needs exactly one spawn point")
	return warnings


## notifies that there are no lives left
func emit_out_of_lives_event() -> void:
	# we notify whoever listens that the lives ran out
	_on_out_of_lives.emit()
