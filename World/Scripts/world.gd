class_name World
extends Node3D

@export_group("Config")
## spawn configs of this level for the enemies, the player and the base
@export var _level_config : LevelConfig

@export_group("References")
## spawns the enemies following the level timeline
@export var _enemy_spawn_manager : SpawnManager
## spawns the player and respawns it while it has lives
@export var _player_spawn_manager : SpawnManager
## spawns the base once
@export var _base_spawn_manager : SpawnManager


## we hand each spawn manager its config; it runs after every child _ready(), so every listener is already subscribed
func _ready() -> void:
	# same order the managers started in before (tree order): enemies, player, base
	_enemy_spawn_manager.configure(_level_config.enemy_timeline_based_spawn_strategy_config)
	# the player spawns right away
	_player_spawn_manager.configure(_level_config.player_lives_based_spawn_strategy_config)
	# the base spawns right away
	_base_spawn_manager.configure(_level_config.base_once_based_spawn_strategy_config)
