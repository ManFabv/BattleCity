class_name SpawnStrategyInterface
extends RefCounted


## here we start the strategy over the spawn points, owner_exited cleans up its timers and subscriptions
func configure(_spawn_points: Array[SpawnPointInterface], _owner_exited: Signal) -> void:
	push_error("configure() should be implemented on inherited classes")
