class_name PlayerCameraApplier
extends Node

@export_group("Events")
## event we listen to in order to know when a new player needs the camera
@export var _on_player_spawned : BaseEvent
@export_group("References")
## the camera used for mouse aiming
@export var _player_camera : PlayerCamera


## we subscribe to the player spawned event
func _ready() -> void:
	_on_player_spawned.subscribe(_on_player_spawned_handler, tree_exited)


## we inject the camera to the player's controller
func _on_player_spawned_handler(entity: ControllableEntity) -> void:
	var player_controller : PlayerController = entity.get_entity_controller() as PlayerController
	if is_instance_valid(player_controller):
		player_controller.set_camera(_player_camera)
