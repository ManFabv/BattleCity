class_name TimelineSpawnEntryConfig
extends Resource

@export_group("Config")
## seconds to wait after the previous entry spawned (the first entry counts from the level start)
@export_range(0.0, 600.0) var spawn_delay_seconds : float = 1.0
## index of the spawn point, inside the manager's spawn points, where this entry spawns (0 is the first one)
@export_range(0, 16) var spawn_point_index : int = 0
## the scene_to_spawn this entry instantiates
@export var scene_to_spawn : PackedScene
