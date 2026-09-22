class_name PlayerSpawnPoint
extends Node3D

## emitted right after instantiate(), before this new player is parented
@export var _on_player_spawned : BaseEvent
## emitted when the player has no lives left (consumed by LevelOutcomeController)
@export var _on_player_out_of_lives : BaseEvent
## the camera used for mouse aiming, wired manually since it's static in the level
@export var _player_camera : PlayerCamera
## how long to wait after death before spawning the next life
@export var _respawn_delay : float = 2.0
## which scene to instantiate, how many lives, and the starting entity/game level
@export var _player_config : PlayerConfig

var _remaining_lives : int
## true only for the very first life of the run; every respawn after a death is false.
## only affects entity level -- initial_game_level is untouched by respawns.
var _is_first_spawn : bool = true


func _ready() -> void:
	_remaining_lives = _player_config.starting_lives
	_spawn_player()


func _spawn_player() -> void:
	var player : ControllableEntity = _player_config.player_scene.instantiate() as ControllableEntity
	_on_player_spawned.emit(player)
	player.global_position = global_position
	player.entity_died.connect(_on_player_died, CONNECT_ONE_SHOT)
	# ControllableEntity._ready() already applied entity level 0 by this point; this only
	# overrides it on the first life, if _player_config asks for a different starting level
	var starting_entity_level : int = _player_config.initial_entity_level if _is_first_spawn else 0
	_is_first_spawn = false
	if starting_entity_level != 0:
		player.set_level(starting_entity_level)
	var entity_controller : EntityController = player.entity_controller
	if entity_controller is PlayerController:
		(entity_controller as PlayerController).set_camera(_player_camera)


func _on_player_died() -> void:
	_remaining_lives -= 1
	if _remaining_lives <= 0:
		_on_player_out_of_lives.emit()
		return
	var timer_context : CustomTimerContext = CustomTimerContext.create_one_shot(_respawn_delay, _spawn_player, tree_exited)
	CustomTimerContext.request(timer_context)
