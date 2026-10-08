class_name KeyboardAndMouseProcessor
extends InputInterface

@export_group("References")
## the player whose position the mouse aim is relative to
@export var _player : ControllableEntity

## player camera, injected by PlayerCameraApplier (via PlayerController) after this player spawns
var _player_camera : PlayerCamera


## injected right after this player's controller is spawned
func set_camera(camera: PlayerCamera) -> void:
	_player_camera = camera


## called when we are going to start using this input
func enter_input_type() -> void:
	pass #TODO: here we can change cursor GUI


## called when we are going to stop using this input and change to another
func exit_input_type() -> void:
	pass #TODO: here we can change cursor GUI


## here we need to calculate where to look according to mouse position
func get_look_at() -> Vector2:
	# we get the mouse position in viewport coordinates
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	# through the camera we convert the mouse position from 2D to 3D
	var world_pos : Vector3 = _player_camera.get_world_position_from_point(mouse_position)
	# we convert it relative to the player
	world_pos -= _player.global_position
	# we return the converted input
	return Vector2(world_pos.x, world_pos.z)
