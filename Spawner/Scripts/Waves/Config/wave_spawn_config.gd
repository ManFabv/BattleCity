class_name WaveSpawnConfig
extends Resource

@export_group("Config")
## seconds to wait before spawning this spawn's node
@export_range(0.1, 60.0) var spawn_delay : float = 1.0
## the node scene to instantiate at this spawn
@export var node_scene : PackedScene
