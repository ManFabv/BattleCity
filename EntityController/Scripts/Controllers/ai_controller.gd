class_name AIController
extends EntityController


@export_group("Navigation")
## this is the component used to make an AI entity to
## navigate through the world
@export var _navigation_agent : NavigationAgent3D

@export_group("Attack Detection")
## max distance at which the player or base is considered a valid attack target
@export var _detection_range : float = 12.0


## safe movement direction, computed asynchronously by the avoidance callback.
## NOTE: this must stay a direction (not a world position); mixing the two caused
## huge one-frame velocity spikes ("teleports") right after a new wander target was set.
var _target_position : Vector3
## where we want to look
var _target_look_at : float
## we need the navigation region RID to be able to get random target positions
## inside the navigation region
var _region_rid : RID
## this will help us to know if we have already shot
var _has_shot : bool = false
## current target used when attacking the player instead of wandering
var _player_target : Node3D
## current target used when attacking the base instead of wandering
var _base_target : Node3D


func get_move_direction() -> Vector3:
	# we take the next position on the navmesh
	var next_position : Vector3 = _navigation_agent.get_next_path_position()
	# we take the direction between our owner position and the next
	# path position to know in which intended direction we need to move
	var intended_direction : Vector3 = owner_controllable_entity.global_position.direction_to(next_position)
	# we set the desired velocity to the navigation agent for avoidance calculation
	# the navigation agent needs the actual desired movement speed
	_navigation_agent.velocity = intended_direction.normalized() * owner_controllable_entity.entity_move_speed
	# Return the safe position which is calculated 
	# by the avoidance callback previously
	return _target_position


func get_look_at_angle() -> float:
	# we are going to take the angle only if we don't reached target
	if not _navigation_agent.is_target_reached():
		# we get the angle where we have to look at
		_target_look_at = atan2(-_target_position.x, -_target_position.z)
	# we return the wanted angle
	return _target_look_at


## we said that the entity is going to shoot
func start_shooting() -> void:
	_has_shot = true


## we said that the entity stopped shooting
func stop_shooting() -> void:
	_has_shot = false


func is_shot_pressed() -> bool:
	return _has_shot


func on_input_type_changed(_event_context: Variant = null) -> void:
	pass # nothing for now


func on_menu_opened(_event_context: Variant = null) -> void:
	pass # nothing for now


## called once by EnemyTargetDispatcher right after this entity spawns
func set_attack_targets(player_target: Node3D, base_target: Node3D) -> void:
	_player_target = player_target
	_base_target = base_target


## moves toward the player instead of a random wander point
func attack_player() -> void:
	# the player may not have been assigned yet, or may have died since
	if not is_instance_valid(_player_target):
		return
	_navigation_agent.set_target_position(_player_target.global_position)


## moves toward the base instead of a random wander point
func attack_base() -> void:
	# the base may not have been assigned yet, or may have been destroyed since
	if not is_instance_valid(_base_target):
		return
	_navigation_agent.set_target_position(_base_target.global_position)


## true if the player is close enough and in direct line of sight
func can_attack_player() -> bool:
	return _has_line_of_sight(_player_target)


## true if the base is close enough and in direct line of sight
func can_attack_base() -> bool:
	return _has_line_of_sight(_base_target)


## checks distance and raycasts toward the target to know if it's a valid attack target
func _has_line_of_sight(target: Node3D) -> bool:
	if not is_instance_valid(target):
		return false
	var origin : Vector3 = owner_controllable_entity.global_position
	var target_position : Vector3 = target.global_position
	if origin.distance_to(target_position) > _detection_range:
		return false
	var space_state : PhysicsDirectSpaceState3D = owner_controllable_entity.get_world_3d().direct_space_state
	var query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, target_position)
	query.exclude = [owner_controllable_entity]
	var result : Dictionary = space_state.intersect_ray(query)
	# no hit means a clear line, otherwise the hit must be the target itself
	return result.is_empty() or result.collider == target


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
	# NOTE: kept as a local variable; _target_position must only ever hold the
	# safe direction produced by the avoidance callback, never a raw world position
	var random_target_position : Vector3 = NavigationServer3D.region_get_random_point(_region_rid, 1, false)
	# we set the new target destination position
	_navigation_agent.set_target_position(random_target_position)


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	# We cache the computed safe velocity as a direction for the entity.
	# The entity is responsible for applying its own movement speed.
	_target_position = safe_velocity.normalized()


func _on_enemy_entity_stats_set() -> void:
	# to avoid issues, we set the agent max avoidance speed equal to
	# the entity movement speed
	# keep a safe default here; actual speed should be set by the owner
	_navigation_agent.max_speed = owner_controllable_entity.entity_move_speed
