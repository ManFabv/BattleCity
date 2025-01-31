extends InputInterface

## How long will the ray be to transform mouse position viewport 2D to world position 3D
@export_range(1, 1000) var ray_length : float = 1000

#input action names variables
var _move_left_name : String
var _move_right_name : String
var _move_up_name : String
var _move_down_name : String
var _fire_prymary_name : String

#main camera
var _camera : Camera3D


func _ready() -> void:
	# we map the input actions according to this player id
	_move_left_name = "move_left_p1"
	_move_right_name = "move_right_p1"
	_move_up_name = "move_up_p1"
	_move_down_name = "move_down_p1"
	_fire_prymary_name = "fire_primary_p1"
	#we get the main camera
	_camera = get_viewport().get_camera_3d()


# here we get the input according to their input axis
func get_input_movement() -> Vector2:
	# we get the input of the keyboard
	var move_input : Vector2 = Input.get_vector(_move_left_name, _move_right_name, _move_up_name, _move_down_name)
	# we return the input value
	return move_input


# here we need to calculate where to look according to mouse position
func get_look_at() -> Vector2:	
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var global_floor_position : Vector3 = Vector3.ZERO
	var from : Vector3 = _camera.project_ray_origin(mouse_pos)
	var to : Vector3 = from + _camera.project_ray_normal(mouse_pos) * ray_length
	var plane : Plane = Plane(Vector3.UP, global_floor_position.y)
	var hit_position = plane.intersects_ray(from, to)
	
	if hit_position:
		var aim : Vector3 = (hit_position - global_floor_position).normalized()
		return Vector2(aim.x, aim.z)
	else:
		return Vector2.ZERO
