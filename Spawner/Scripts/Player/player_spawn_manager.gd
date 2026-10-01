class_name PlayerSpawnManager
extends Node

@export_group("Events")
## event we listen to know which player to watch for its death (emitted by the spawn point)
@export var _on_player_spawned : BaseEvent
## emitted when the player has no lives left (consumed by LevelResultController)
@export var _on_player_out_of_lives : BaseEvent
@export_group("References")
## the spawn point that instantiates every player life
@export var _spawn_point : SpawnPointInterface
## the shared timer manager used to request the respawn delay timer
@export var _timer_manager : TimerManagerResource
@export_group("Config")
## how many lives the player has and how long to wait to respawn
@export var _player_spawn_manager_config : PlayerSpawnManagerConfig

var _remaining_lives : int


## at the beginning we spawn the first life
func _ready() -> void:
	_remaining_lives = _player_spawn_manager_config.starting_lives
	_on_player_spawned.subscribe(_on_player_spawned_handler, tree_exited)
	_spawn_point.spawn()


func _on_player_spawned_handler(player: ControllableEntity) -> void:
	player.entity_died.connect(_on_player_died, CONNECT_ONE_SHOT)


func _on_player_died() -> void:
	_remaining_lives -= 1
	if _remaining_lives <= 0:
		_on_player_out_of_lives.emit()
		return
	_timer_manager.create_one_shot(_player_spawn_manager_config.respawn_delay, _spawn_point.spawn, tree_exited)
