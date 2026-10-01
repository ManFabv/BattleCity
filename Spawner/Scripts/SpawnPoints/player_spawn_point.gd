class_name PlayerSpawnPoint
extends SpawnPointInterface

@export_group("Events")
## emitted right after instantiate(), before this new player is parented
@export var _on_player_spawned : BaseEvent
## emitted when the player has no lives left (consumed by LevelResultController)
@export var _on_player_out_of_lives : BaseEvent
@export_group("References")
## the camera used for mouse aiming, wired manually since it's static in the level
@export var _player_camera : PlayerCamera
## the shared timer manager used to request the respawn delay timer
@export var _timer_manager : TimerManagerResource
@export_group("Config")
## how long to wait after death before spawning the next life
@export_range(0.1, 10.0) var _respawn_delay : float = 2.0
## which scene to instantiate, how many lives, and the starting entity/game level
@export var _player_spawn_point_config : PlayerSpawnPointConfig

var _remaining_lives : int

## the interface spawns the first player
func _ready() -> void:
	super._ready()
	_remaining_lives = _player_spawn_point_config.starting_lives


func spawn() -> void:
	var player : ControllableEntity = _player_spawn_point_config.player_scene.instantiate() as ControllableEntity
	# the level must be set before emitting the event: the container parents the player there and _ready() applies it
	# only the very first life of the run (no death yet) uses the initial entity level
	var is_first_spawn : bool = _remaining_lives == _player_spawn_point_config.starting_lives
	player.set_initial_level(_player_spawn_point_config.initial_entity_level if is_first_spawn else 0)
	_on_player_spawned.emit(player)
	player.global_position = global_position
	player.entity_died.connect(_on_player_died, CONNECT_ONE_SHOT)
	var entity_controller : EntityControllerInterface = player.get_entity_controller()
	if entity_controller is PlayerController:
		(entity_controller as PlayerController).set_camera(_player_camera)


func _on_player_died() -> void:
	_remaining_lives -= 1
	if _remaining_lives <= 0:
		_on_player_out_of_lives.emit()
		return
	_timer_manager.create_one_shot(_respawn_delay, spawn, tree_exited)
