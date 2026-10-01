class_name BaseSpawnManager
extends Node

@export_group("References")
## the spawn point that instantiates the base
@export var _spawn_point : SpawnPointInterface


## at the beginning we spawn the base
func _ready() -> void:
	_spawn_point.spawn()
