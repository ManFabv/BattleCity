class_name PlayerCamera
extends Camera3D

## height of the horizontal "imaginary" plane used by gameplay aiming
## (imaginary means that we don't have a physical plane in the world, 
## we just use this height to calculate the intersection of the camera ray 
## with this plane)
@export var _gameplay_plane_y_position : float = 0.0

## this will convert a 2D point to 3D
func get_world_position_from_point(point: Vector2) -> Vector3:
	# get the origin of the camera ray
	var ray_origin : Vector3 = project_ray_origin(point)
	# get the direction of the camera ray
	var ray_direction : Vector3 = project_ray_normal(point)
	# we prevent division by zero in case the ray is parallel to the gameplay plane
	if is_zero_approx(ray_direction.y):
		return ray_origin
	# calculate the distance to the gameplay plane
	# plane equation: y = _gameplay_plane_y_position
	# ray equation: ray_origin + ray_direction * t
	# we want to find t such that the ray intersects the plane
	# so we set the y component of the ray equation equal to the plane's y position
	# ray_origin.y + ray_direction.y * t = _gameplay_plane_y_position
	# solve for t:
	# t = (_gameplay_plane_y_position - ray_origin.y) / ray_direction.y
	# where t is our ray_distance, which is the distance along the ray to the intersection point
	var ray_distance : float = (_gameplay_plane_y_position - ray_origin.y) / ray_direction.y
	# return the point where the ray intersects the gameplay plane
	return ray_origin + ray_direction * ray_distance