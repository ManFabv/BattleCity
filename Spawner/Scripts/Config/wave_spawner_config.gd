class_name WaveSpawnerConfig
extends Resource

## parallel arrays: at step i, wait spawn_delays[i] seconds,
## then instantiate node_scenes[i]
@export var spawn_delays: Array[float]
@export var node_scenes: Array[PackedScene]
