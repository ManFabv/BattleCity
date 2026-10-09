class_name TimelineSpawnEntryConfig
extends Resource

@export_group("Config")
## seconds to wait after the previous entry spawned (the first entry counts from the level start)
@export_range(0.0, 600.0) var spawn_delay_seconds : float = 1.0:
	set(new_value):
		# we prevent negative delays
		spawn_delay_seconds = maxf(new_value, 0.0)
## id of the spawn point, among the manager's spawn points, where this entry spawns (see SpawnPoint.spawn_point_id)
@export_range(0, 99) var spawn_point_id : int = 0:
	set(new_value):
		# we prevent negative ids
		spawn_point_id = maxi(new_value, 0)
## the enemy scene this entry instantiates, it carries its own entity levels
@export var scene_to_spawn : PackedScene
