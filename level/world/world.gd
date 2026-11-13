class_name World
extends Node3D

@export_group("References")
## spawns the enemies following the level timeline
@export var _enemy_spawn_manager : SpawnManager
## spawns the player and respawns it while it has lives
@export var _player_spawn_manager : SpawnManager
## spawns the base once
@export var _base_spawn_manager : SpawnManager
## the text shown before the level starts; the player and the enemies wait until it ends
@export var _level_start_prompt : LevelStartPrompt


## we start the base and show the start prompt; it runs after every child _ready(), so every listener is already subscribed
func _ready() -> void:
	# the base is static, it spawns right away so the navmesh rebake doesn't wait for the prompt
	_base_spawn_manager.start()
	# nothing that moves spawns until the prompt ends
	_level_start_prompt.subscribe_to_finished(_on_level_start_prompt_finished)
	_level_start_prompt.show_prompt()


## the prompt ended: the enemy timeline starts counting and the player spawns
func _on_level_start_prompt_finished() -> void:
	_enemy_spawn_manager.start()
	_player_spawn_manager.start()
