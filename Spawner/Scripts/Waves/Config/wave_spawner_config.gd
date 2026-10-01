class_name WaveSpawnerConfig
extends Resource

## parallel arrays: at step i, wait spawn_delays[i] seconds,
## then instantiate node_scenes[i]
@export var spawn_delays: Array[float]
@export var node_scenes: Array[PackedScene]

## current step in the wave; once it reaches node_scenes.size() the wave is finished
var current_index : int = 0:
	set(new_value):
		current_index = max(new_value, 0)


## brings the wave back to its first step
func reset_index() -> void:
	current_index = 0


## moves to the next step, without wrapping back to the start
func advance_index() -> void:
	current_index += 1


## true once every node in the wave has already been spawned
func is_finished() -> bool:
	return current_index >= node_scenes.size()


## delay to wait before spawning the node at the current step
func current_delay() -> float:
	return spawn_delays[current_index]


## node scene to instantiate at the current step
func current_node_scene() -> PackedScene:
	return node_scenes[current_index]
