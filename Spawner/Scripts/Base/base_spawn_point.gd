class_name BaseSpawnPoint
extends SpawnPointInterface

@export_group("Events")
## emitted right after instantiate(), before the new base is parented
@export var _on_base_spawned : BaseEvent
@export_group("Config")
## which base config we will apply to the base
@export var _base_spawn_point_config : BaseSpawnPointConfig


## instantiate the base
func spawn() -> void:
	# we instantiate the base scene
	var base : Base = _base_spawn_point_config.base_scene.instantiate() as Base
	# we notify that the base is spawned
	_on_base_spawned.emit(base)
	# we assign it to the spawner position
	base.global_position = global_position
