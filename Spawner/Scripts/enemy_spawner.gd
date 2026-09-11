extends Node3D

## list of enemies availables for spawn
@export var _enemies: Array[PackedScene]

## the event where we notify that an enemy should be added to the tree
@export var _on_enemy_spawned : BaseEvent

## TODO: this logic will be improved: we setup the initial spawn logic. 
func _ready() -> void:
	# we take a random time to spawn a new enemy
	var time_between_spawns : float = randf_range(5, 10)
	# we create a timer to handle when we want to spawn a new enemy
	var timer_context : TimerContext = TimerContext.create_loop(time_between_spawns, _spawn_enemy, tree_exited)
	# we subscribe the timer so it can start ticking
	TimerContext.request(timer_context)


## TODO: this logic will be improved: we instantiate a new enemy in the level
func _spawn_enemy() -> void:
	# we select a random enemy
	var enemy_index : int = randi_range(0, _enemies.size() - 1)
	# we instantiate it
	var enemy : ControllableEntity = _enemies[enemy_index].instantiate() as ControllableEntity
	# we notify that a new enemy is spawned so the container can add it to the tree
	_on_enemy_spawned.emit(enemy)
	# we move the enemy to the spawner position
	enemy.global_position = global_position
