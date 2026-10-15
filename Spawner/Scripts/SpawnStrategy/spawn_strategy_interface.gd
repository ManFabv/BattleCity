class_name SpawnStrategyInterface
extends RefCounted


## here we start the strategy over the spawn points, owner_exited cleans up its timers and subscriptions
func start(_spawn_points: Array[SpawnPoint], _owner_exited: Signal) -> void:
	push_error("start() should be implemented on inherited classes")
