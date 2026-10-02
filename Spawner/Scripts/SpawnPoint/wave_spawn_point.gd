class_name WaveSpawnPoint
extends SpawnPointInterface

@export_group("Config")
## spawns (delay and scene_to_spawn) of the wave this spawn point runs
@export var wave_spawns : WaveSpawns


## TODO: nothing planned yet for wave spawn points
func _on_node_spawned(_node: Node3D) -> void:
	pass # nothing for now
