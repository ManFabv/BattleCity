class_name PlayerSpawnPoint
extends SpawnPointInterface

@export_group("Events")
## emitted right after instantiate(), before this new player is parented
@export var _on_player_spawned : BaseEvent
@export_group("References")
## the camera used for mouse aiming, wired manually since it's static in the level
@export var _player_camera : PlayerCamera
@export_group("Config")
## which scene to instantiate
@export var _player_spawn_point_config : PlayerSpawnPointConfig


## instantiate the player
func spawn() -> void:
	var player : ControllableEntity = _player_spawn_point_config.player_scene.instantiate() as ControllableEntity
	# TODO: set the initial entity level from the player save (player.set_initial_level()) before emitting the event:
	# the container parents the player there and _ready() applies it. Until then every player starts at level 0
	_on_player_spawned.emit(player)
	player.global_position = global_position
	var entity_controller : EntityControllerInterface = player.get_entity_controller()
	if entity_controller is PlayerController:
		(entity_controller as PlayerController).set_camera(_player_camera)
