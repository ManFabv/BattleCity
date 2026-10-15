class_name World
extends Node3D

@export_group("References")
## spawns the enemies following the level timeline
@export var _enemy_spawn_manager : SpawnManager
## spawns the player and respawns it while it has lives
@export var _player_spawn_manager : SpawnManager
## spawns the base once
@export var _base_spawn_manager : SpawnManager


## we start each spawn manager; it runs after every child _ready(), so every listener is already subscribed
func _ready() -> void:
	# the enemy timeline starts counting now
	_enemy_spawn_manager.configure()
	# the player spawns right away
	_player_spawn_manager.configure()
	# the base spawns right away
	_base_spawn_manager.configure()
