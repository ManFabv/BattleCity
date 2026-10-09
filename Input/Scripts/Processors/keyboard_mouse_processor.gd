class_name KeyboardAndMouseProcessor
extends InputInterface

@export_group("References")
## the player whose position the mouse aim is relative to
@export var _player : ControllableEntity

## the active camera of the viewport, used to convert the mouse position to the world
var _player_camera : PlayerCamera


## we take the active camera from the viewport, it is already current when the player spawns
func _ready() -> void:
	_player_camera = get_viewport().get_camera_3d() as PlayerCamera
	# we report a viewport without a PlayerCamera, the mouse aim would do nothing
	if not is_instance_valid(_player_camera):
		push_error("KeyboardAndMouseProcessor: the active camera is not a PlayerCamera")


## called when we are going to start using this input
func enter_input_type() -> void:
	pass #TODO: here we can change cursor GUI


## called when we are going to stop using this input and change to another
func exit_input_type() -> void:
	pass #TODO: here we can change cursor GUI


## here we need to calculate where to look according to mouse position
func get_look_at() -> Vector2:
	# without a camera to project the mouse, the aim stays at its default angle
	var look_at : Vector2 = Vector2.ZERO
	# only a PlayerCamera converts the mouse position to the world
	if is_instance_valid(_player_camera):
		# we get the mouse position in viewport coordinates
		var mouse_position : Vector2 = get_viewport().get_mouse_position()
		# through the camera we convert the mouse position from 2D to 3D
		var world_pos : Vector3 = _player_camera.get_world_position_from_point(mouse_position)
		# we convert it relative to the player
		world_pos -= _player.global_position
		# we keep the floor plane components
		look_at = Vector2(world_pos.x, world_pos.z)
	return look_at
