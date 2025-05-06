class_name AIController
extends EntityController

@export_group("Navigation")
## this is the component used to make an AI entity to
## navigate through the world
@export var _navigation_agent : NavigationAgent3D

@export_group("References")
## who is the AI entity that we want to move
@export var _owner : ControllableEntity

## where we want to move
var _target_position : Vector3
## where we want to look
var _target_look_at : float


func get_move_direction() -> Vector3:
	# we take the next position on the navmesh
	var next_position : Vector3 = _navigation_agent.get_next_path_position()
	# we take the direction between our owner position and the next
	# path position to know in which direction we need to move
	_target_position = _owner.global_position.direction_to(next_position)
	# we return the desired position
	return _target_position


func get_look_at_angle() -> float:
	# we are going to take the angle only if we don't reached target
	if not _navigation_agent.is_target_reached():
		# we get the angle where we have to look at
		_target_look_at = atan2(-_target_position.x, -_target_position.z)
	# we return the wanted angle
	return _target_look_at


func is_shot_pressed() -> bool:
	return false


func on_input_type_changed() -> void:
	pass


func on_menu_opened() -> void:
	pass
