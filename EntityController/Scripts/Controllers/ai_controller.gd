class_name AIController
extends EntityController


@export_group("Navigation")
## this is the component used to make an AI entity to
## navigate through the world
@export var _navigation_agent : NavigationAgent3D

@export_group("Attack Detection")
## used to check line of sight (range, vision cone and obstacles) toward attack targets
@export var _attack_detector : TargetDetector


## safe movement direction, computed asynchronously by the avoidance callback.
## NOTE: this must stay a direction (not a world position); mixing the two caused
## huge one-frame velocity spikes ("teleports") right after a new wander target was set.
var _target_position : Vector3
## where we want to look
var _target_look_at : float
## navigation region RID used to get random target positions inside the
## navigation region; handed to us by WaveSpawnerManager when we spawn
var _region_rid : RID
## this will help us to know if we have already shot
var _has_shot : bool = false
## current target used when attacking the player instead of wandering
var _player_target : Node3D
## current target used when attacking the base instead of wandering
var _base_target : Node3D
## whichever of the two above is currently being attacked, if any; used to aim the look-at angle
var _current_attack_target : Node3D


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
	# while attacking, aim straight at the target instead of following the
	# avoidance movement direction (which isn't reliable for aiming)
	if is_instance_valid(_current_attack_target):
		var direction_to_target : Vector3 = owner_controllable_entity.global_position.direction_to(_current_attack_target.global_position)
		_target_look_at = atan2(-direction_to_target.x, -direction_to_target.z)
	# we are going to take the angle only if we don't reached target
	elif not _navigation_agent.is_target_reached():
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


## called once by WaveSpawnerManager right after this entity spawns
func set_navigation_region_rid(region_rid: RID) -> void:
	_region_rid = region_rid


## aims at the player instead of wandering; the entity holds its ground and looks at it
func attack_player() -> void:
	# the player may not have been assigned yet, or may have died since
	if not is_instance_valid(_player_target):
		return
	_current_attack_target = _player_target


## aims at the base instead of wandering; the entity holds its ground and looks at it
func attack_base() -> void:
	# the base may not have been assigned yet, or may have been destroyed since
	if not is_instance_valid(_base_target):
		return
	_current_attack_target = _base_target


## true if the player is close enough and in direct line of sight
func can_attack_player() -> bool:
	if not is_instance_valid(_player_target):
		return false
	return _attack_detector.has_line_of_sight(_player_target)


## true if the base is close enough and in direct line of sight
func can_attack_base() -> bool:
	if not is_instance_valid(_base_target):
		return false
	return _attack_detector.has_line_of_sight(_base_target)


## this will help us take a random point inside navigation mesh
func set_random_target_position() -> void:
	# back to wandering, so the look-at angle should follow movement again
	_current_attack_target = null
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
