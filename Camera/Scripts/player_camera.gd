class_name PlayerCamera
extends Camera3D

@export_group("Config")
## how far any ray from the camera will be
@export_range(0.1, 1000.0) var _world_position_ray_length : float = 1000.0:
	set(new_value):
		# we prevent negative lengths, which would cast the ray backwards
		_world_position_ray_length = maxf(new_value, 0.0)

@export_group("References")
## we use this to trigger a raycast and convert a 2D point to world 3D
@export var _ray_cast_3d: RayCast3D

## if we don't hit anything, we return the last direction
var _last_position_collision : Vector3 = Vector3.ZERO
## we cache the last queried 2D point (pointing to the center of the map by default)
var _last_point_query : Vector2 = Vector2.ZERO

## this will convert a 2D point to 3D
func _physics_process(_delta: float) -> void:
	# we set the origin as the ray origin
	_ray_cast_3d.global_position = project_ray_origin(_last_point_query)
	# we project the given point
	_ray_cast_3d.target_position = project_local_ray_normal(_last_point_query) * _world_position_ray_length
	# we force to update the collision for this new ray
	_ray_cast_3d.force_raycast_update()
	#if collided with something, we get that collision point
	if _ray_cast_3d.is_colliding():
		_last_position_collision = _ray_cast_3d.get_collision_point()
	
## this will convert a 2D point to 3D
func get_world_position_from_point(point: Vector2) -> Vector3:
	# we cache the current point to be queried
	_last_point_query = point
	# we return the calculated position
	return _last_position_collision
