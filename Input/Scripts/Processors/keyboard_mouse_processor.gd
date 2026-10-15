class_name KeyboardAndMouseProcessor
extends InputInterface

@export_group("References")
## the player whose position the mouse aim is relative to
@export var _player : ControllableEntity

@export_group("Config")
## height over the player position of the plane the mouse aims at: the cannon height, so the aim doesn't drift with the camera angle
@export_range(0.0, 5.0) var _aim_height_offset : float = 0.35


## called when we are going to start using this input
func enter_input_type() -> void:
	pass # TODO: show the mouse cursor


## called when we are going to stop using this input and change to another
func exit_input_type() -> void:
	pass # TODO: hide the mouse cursor


## here we need to calculate where to look according to mouse position
func get_look_at() -> Vector2:
	# the aim stays at its default angle while the mouse ray misses the aim plane
	var look_at : Vector2 = Vector2.ZERO
	# we ask the viewport for its active camera each time, so a camera change is followed
	var active_camera : Camera3D = get_viewport().get_camera_3d()
	# we get the mouse position in viewport coordinates
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	# the flat plane at the cannon height, where the aim point lives
	var aim_plane : Plane = Plane(Vector3.UP, _player.global_position.y + _aim_height_offset)
	# the mouse ray crosses the plane at the aimed point, or never when it is parallel to it
	var aim_point : Variant = aim_plane.intersects_ray(active_camera.project_ray_origin(mouse_position), active_camera.project_ray_normal(mouse_position))
	# we only aim when the ray did cross the plane
	if aim_point is Vector3:
		# we keep the floor plane components relative to the player
		var relative_aim_point : Vector3 = (aim_point as Vector3) - _player.global_position
		look_at = Vector2(relative_aim_point.x, relative_aim_point.z)
	return look_at
