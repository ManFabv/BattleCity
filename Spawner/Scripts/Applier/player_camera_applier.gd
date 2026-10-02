class_name PlayerCameraApplier
extends SpawnedNodeApplierInterface

@export_group("References")
## the camera used for mouse aiming
@export var _player_camera : PlayerCamera


## we inject the camera to the player's controller
func _apply(entity: ControllableEntity) -> void:
	var player_controller : PlayerController = entity.get_entity_controller() as PlayerController
	if is_instance_valid(player_controller):
		player_controller.set_camera(_player_camera)
