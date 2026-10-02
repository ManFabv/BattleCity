class_name WaveSpawnConfig
extends Resource

@export_group("Config")
## seconds to wait before spawning this spawn's node
@export_range(0.1, 60.0) var spawn_delay : float = 1.0
## the scene_to_spawn this step of the wave instantiates
@export var scene_to_spawn : PackedScene
