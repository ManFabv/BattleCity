class_name BaseSpawnPoint
extends SpawnPointInterface

@export_group("Events")
## emitted right after instantiate(), before the new base is parented (consumed by BaseContainer)
@export var _on_base_spawned : BaseEvent
@export_group("Config")
## which base to spawn (scene to instantiate)
@export var _base_spawn_point_config : BaseSpawnPointConfig


## at the beginning we spawn the base
func _ready() -> void:
	# deferred so every listener is subscribed no matter where this node sits in the tree
	spawn.call_deferred()


func spawn() -> void:
	# we instantiate the base scene
	var base : Base = _base_spawn_point_config.base_scene.instantiate() as Base
	# we notify that the base is spawned
	_on_base_spawned.emit(base)
	# we assign it to the spawner position
	base.global_position = global_position
