@tool
class_name SpawnStrategyConfig
extends Resource


## creates a spawn strategy instance matching this config
func create_spawn_strategy() -> SpawnStrategyInterface:
	push_error("create_spawn_strategy() should be implemented on inherited classes")
	return null


## what is wrong with this config for the given spawn points, empty when it can start
func get_configuration_warnings(_spawn_points: Array[SpawnPoint]) -> PackedStringArray:
	push_error("get_configuration_warnings() should be implemented on inherited classes")
	return PackedStringArray()
