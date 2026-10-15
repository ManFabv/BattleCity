@tool
class_name OnceBasedSpawnStrategyConfig
extends SpawnStrategyConfig

@export_group("References")
## the scene_to_spawn to instantiate once on the first spawn point
@export var scene_to_spawn : PackedScene


## creates the once based spawn strategy that uses this config's scene_to_spawn
func create_spawn_strategy() -> SpawnStrategyInterface:
	return OnceBasedSpawnStrategy.new(self)


## the scene is spawned on the first spawn point, so it needs a scene and at least one spawn point
func get_configuration_warnings(spawn_points: Array[SpawnPoint]) -> PackedStringArray:
	# we collect everything that is wrong
	var warnings : PackedStringArray = PackedStringArray()
	# without a scene there is nothing to spawn
	if not is_instance_valid(scene_to_spawn):
		warnings.append("once based spawn strategy needs a scene to spawn")
	# without spawn points there is nowhere to spawn
	if spawn_points.is_empty():
		warnings.append("once based spawn strategy needs at least one spawn point")
	return warnings
