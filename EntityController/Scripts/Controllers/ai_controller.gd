class_name AIController
extends EntityControllerInterface

## emitted when the current wander target isn't reached before its timeout;
## the state machine reacts to this the same way it reacts to reaching the target
signal wander_timed_out

@export_group("Navigation")
## this is the component used to make an AI entity to navigate through the world
@export var _navigation_agent : NavigationAgent3D
@export_group("Attack Detection")
## used to check line of sight (range, vision cone and obstacles) toward attack targets
@export var _attack_detector : TargetDetectorInterface
@export_group("References")
## the shared timer manager used to request the wander target timeout timer
@export var _timer_manager : TimerManagerResource
@export_group("Level")
## the level manager of the owner entity, it notifies us every time the stats of a level are applied
@export var _entity_level_manager : EntityLevelManager
@export_group("Wander Setup")
## seconds the entity has to reach the current wander target before giving up on it (unreachable point or blocked way)
@export_range(0.1, 20.0) var _wander_timeout_seconds : float = 10.0:
	set(new_value):
		# we prevent negative timeouts
		_wander_timeout_seconds = maxf(new_value, 0.0)


## safe movement direction, computed asynchronously by the avoidance callback
var _target_position : Vector3
## where we want to look
var _target_look_at : float
## navigation region RID used to get random target positions inside the
## navigation region; handed to us by EnemyNavigationApplier when we spawn
var _region_rid : RID
## this will help us to know if we have already shot
var _has_shot : bool = false
## current target used when attacking the player instead of wandering
var _player_target : ControllableEntity
## current target used when attacking the base instead of wandering
var _base_target : Base
## whichever of the two above is currently being attacked, if any; used to aim the look-at angle
var _current_attack_target : Node3D
## timer used to give up on a wander target that takes too long to reach
var _wander_timeout_timer : CustomTimer


## We instantiate the timer and connect the signals
func _ready() -> void:
	_wander_timeout_timer = _timer_manager.create_manual(
			_wander_timeout_seconds, 
			_on_wander_timeout, 
			tree_exited, 
			false)
	_entity_level_manager.subscribe_to_configured_for_level(_on_entity_configured_for_level)


func get_move_direction() -> Vector3:
	# we take the next position on the navmesh
	var next_position : Vector3 = _navigation_agent.get_next_path_position()
	# we take the direction between our owner position and the next
	# path position to know in which intended direction we need to move
	var intended_direction : Vector3 = owner_controllable_entity.global_position.direction_to(next_position)
	# we set the desired velocity to the navigation agent for avoidance calculation
	# the navigation agent needs the actual desired movement speed
	_navigation_agent.velocity = intended_direction.normalized() * owner_controllable_entity.get_entity_move_speed()
	# Return the safe position which is calculated 
	# by the avoidance callback previously
	return _target_position


func get_look_at_angle() -> float:
	# while attacking, aim straight at the target instead of following the
	# avoidance movement direction (which isn't reliable for aiming)
	if is_instance_valid(_current_attack_target):
		var direction_to_target : Vector3 = owner_controllable_entity.global_position.direction_to(
				_current_attack_target.global_position)
		_target_look_at = atan2(-direction_to_target.x, -direction_to_target.z)
	# we are going to take the angle only if we don't reached target
	elif _can_aim():
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


## called once by EnemyTargetApplier right after this entity spawns
func set_attack_targets(player_target: ControllableEntity, base_target: Base) -> void:
	_player_target = player_target
	_base_target = base_target


## called once by EnemyNavigationApplier right after this entity spawns
func set_navigation_region_rid(region_rid: RID) -> void:
	_region_rid = region_rid


## aims at the player instead of wandering; the entity holds its ground and looks at it
func attack_player() -> void:
	# the player may not have been assigned yet, or may have died since
	if is_instance_valid(_player_target):
		_current_attack_target = _player_target


## aims at the base instead of wandering; the entity holds its ground and looks at it
func attack_base() -> void:
	# the base may not have been assigned yet, or may have been destroyed since
	if is_instance_valid(_base_target):
		_current_attack_target = _base_target


## freezes the look-at angle at whatever it was aiming when the shot is taken,
## so the entity doesn't keep turning to follow the target while it fires
func stop_aiming() -> void:
	_current_attack_target = null


## true if the player is close enough and in direct line of sight
func can_attack_player() -> bool:
	if not is_instance_valid(_player_target):
		return false
	return _attack_detector.has_detected_target(_player_target)


## true if the base is close enough and in direct line of sight
func can_attack_base() -> bool:
	if not is_instance_valid(_base_target):
		return false
	return _attack_detector.has_detected_target(_base_target)


## this will help us take a random point inside navigation mesh
func set_random_target_position() -> void:
	# back to wandering, so the look-at angle should follow movement again
	_current_attack_target = null
	# get a random point from the navigation region
	var random_target_position : Vector3 = _get_random_wander_target()
	# we set the new target destination position
	_navigation_agent.set_target_position(random_target_position)
	# restart the timeout for this new target
	_wander_timeout_timer.start(_wander_timeout_seconds)


## picks a random point on the navigation region; if it can't be reached
## the wander timeout takes care of giving up on it
func _get_random_wander_target() -> Vector3:
	return NavigationServer3D.region_get_random_point(
			_region_rid, 
			_navigation_agent.navigation_layers, 
			false)


## the entity only turns toward its movement direction while it hasn't reached the target
func _can_aim() -> bool:
	return not _navigation_agent.is_target_reached()


## a timeout can still fire after the target was already reached (ex: while attacking);
## in that case is_target_reached() is true and there's nothing to give up on
func _on_wander_timeout() -> void:
	if not _navigation_agent.is_target_reached():
		# give up on the current wander target by clamping it to where we are, so the entity
		# stops moving exactly as if it had reached it, and let the state machine move on
		# to the next state instead of retrying wander forever
		_navigation_agent.set_target_position(owner_controllable_entity.global_position)
		wander_timed_out.emit()


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	# We cache the computed safe velocity as a direction for the entity.
	# The entity is responsible for applying its own movement speed.
	_target_position = safe_velocity.normalized()


func _on_entity_configured_for_level() -> void:
	# to avoid issues, we set the agent max avoidance speed equal to
	# the entity movement speed
	_navigation_agent.max_speed = owner_controllable_entity.get_entity_move_speed()
