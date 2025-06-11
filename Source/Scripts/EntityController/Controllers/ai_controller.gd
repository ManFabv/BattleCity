class_name AIController
extends EntityController

@export_group("Navigation")
## this is the component used to make an AI entity to
## navigate through the world
@export var _navigation_agent : NavigationAgent3D

## where we want to move
var _target_position : Vector3
## where we want to look
var _target_look_at : float
## we need the navigation region RID to be able to get random target positions
## inside the navigation region
var _region_rid : RID


func get_move_direction() -> Vector3:
	# we take the next position on the navmesh
	var next_position : Vector3 = _navigation_agent.get_next_path_position()
	# we take the direction between our owner position and the next
	# path position to know in which direction we need to move
	_target_position = owner_controllable_entity.global_position.direction_to(next_position)
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
	return false # nothing for now


func on_input_type_changed() -> void:
	pass # nothing for now


func on_menu_opened() -> void:
	pass # nothing for now


# in order to get a random target position we need to set the region rid
func _get_region_rid() -> void:
	# we take the navigation map rid
	var map_rid : RID = _navigation_agent.get_navigation_map()
	# we update the map to be able to get the map regions
	NavigationServer3D.map_force_update(map_rid)
	# we get the first map rid
	_region_rid = NavigationServer3D.map_get_regions(map_rid)[0]


## this will help us take a random point inside navigation mesh
func set_random_target_position() -> void:
	# everytime we set a new target position, we update the region rid
	_get_region_rid()
	# get a random point from NavigationRegion2D
	_target_position = NavigationServer3D.region_get_random_point(_region_rid, 1, false)
	# we set the new target destination position
	_navigation_agent.set_target_position(_target_position)


# this will notify when the entity reaches the target destination
func connect_on_target_reached_signal(on_target_reached : Callable) -> void:
	_navigation_agent.navigation_finished.connect(on_target_reached)
