class_name SpawnStrategyConfigInterface
extends Resource


## creates a spawn strategy instance matching this config
func create_spawn_strategy() -> SpawnStrategyInterface:
	push_error("create_spawn_strategy() should be implemented on inherited classes")
	return null
