class_name AIController
extends EntityController

## Emitted when the AI decides it wants to perform a shot.
signal _shot_requested


@export_group("Navigation")
## this is the component used to make an AI entity to
## navigate through the world
@export var _navigation_agent : NavigationAgent3D

@export_group("Weapons")
## this is the component used to make an AI entity to shoot
@export var _weapon_system : WeaponSystem

## where we want to move
var _target_position : Vector3
## where we want to look
var _target_look_at : float
## we need the navigation region RID to be able to get random target positions
## inside the navigation region
var _region_rid : RID
## this will help us to know if we have already shot
var _has_shot : bool = false


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


## we said that the entity is going to shoot, so we directly request a shot
## and emit the signal to notify that we have shot
func start_shooting() -> void:
	_has_shot = true
	_shot_requested.emit()


## we said that the entity stopped shooting, so we set the status to true and emit the signal to notify that we have shot
func stop_shooting() -> void:
	_has_shot = false


func is_shot_pressed() -> bool:
	return _has_shot


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


func connect_on_target_reached_signal(on_navigation_agent_3d_target_reached : Callable) -> void:
	_navigation_agent.navigation_finished.connect(on_navigation_agent_3d_target_reached)


func connect_on_shot_fired_signal(on_weapon_system_shot_fired : Callable) -> void:
	_weapon_system.connect_on_shot_fired_signal(on_weapon_system_shot_fired)
