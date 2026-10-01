class_name BaseSpawnPoint
extends Node3D

## emitted right after instantiate(), before the new base is parented (consumed by BaseContainer)
@export var _on_base_spawned : BaseEvent
## which scene to instantiate as the base
@export var _base_scene : PackedScene


## at the beginning we spawn the base
func _ready() -> void:
	_spawn_base()


func _spawn_base() -> void:
	# we instantiate the base scene
	var base : Base = _base_scene.instantiate() as Base
	# we notify that the base is spawned
	_on_base_spawned.emit(base)
	# we assign it to the spawner position
	base.global_position = global_position
