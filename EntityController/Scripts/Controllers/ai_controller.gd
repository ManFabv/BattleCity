class_name AIController
extends EntityControllerInterface

@export_group("Navigation")
## this is the component used to make an AI entity to navigate through the world
@export var _navigation_agent : NavigationAgent3D
@export_group("Attack Detection")
## used to check line of sight (range, vision cone and obstacles) toward attack targets
@export var _attack_detector : SightAttackDetector
@export_group("Events")
## event announcing that a grenade was picked up, this enemy reacts by eliminating itself
@export var _on_grenade_picked_up : BaseEvent
## event announcing a new player instance, this enemy takes it as its player target (ex: after a respawn)
@export var _on_player_spawned : BaseEvent

## safe movement direction, computed asynchronously by the avoidance callback
var _safe_move_direction : Vector3
## where we want to look
var _target_look_at : float
## true while the state machine wants this entity to shoot, read as the shoot input
var _has_shot : bool = false
## current target used when attacking the player instead of wandering
var _player_target : ControllableEntity
## current target used when attacking the base instead of wandering
var _base_target : Base
## whichever of the two above is currently being attacked, if any; used to aim the look-at angle
var _current_attack_target : Node3D


## we subscribe to the events
func _ready() -> void:
	_on_grenade_picked_up.subscribe(_on_grenade_picked_up_handler, tree_exited)
	_on_player_spawned.subscribe(_on_player_spawned_handler, tree_exited)


## feeds the agent the desired velocity and returns the safe direction computed by the avoidance
func get_move_direction() -> Vector3:
	# we take the next position on the navmesh
	var next_position : Vector3 = _navigation_agent.get_next_path_position()
	# we take the direction from our owner to the next path position
	var intended_direction : Vector3 = owner_controllable_entity.global_position.direction_to(next_position)
	# we read the speed every tick, so level ups and stat modifiers reach the agent
	var move_speed : float = owner_controllable_entity.get_entity_move_speed()
	# the avoidance never returns a safe velocity faster than the entity moves
	_navigation_agent.max_speed = move_speed
	# we set the desired velocity to the navigation agent for avoidance calculation
	_navigation_agent.velocity = intended_direction * move_speed
	# the safe direction comes from the previous avoidance callback
	return _safe_move_direction


## aims straight at the attack target, or along the movement while wandering
func get_look_at_angle() -> float:
	# while attacking, the avoidance direction isn't reliable for aiming
	if is_instance_valid(_current_attack_target):
		var direction_to_target : Vector3 = owner_controllable_entity.global_position.direction_to(
				_current_attack_target.global_position)
		_target_look_at = atan2(-direction_to_target.x, -direction_to_target.z)
	# we only follow the movement while the target isn't reached
	elif _can_aim():
		# we get the angle where we have to look at
		_target_look_at = atan2(-_safe_move_direction.x, -_safe_move_direction.z)
	# we return the wanted angle
	return _target_look_at


## the entity starts holding the shoot input
func start_shooting() -> void:
	_has_shot = true


## the entity releases the shoot input
func stop_shooting() -> void:
	_has_shot = false


## true while the state machine holds the shoot input
func is_shot_pressed() -> bool:
	return _has_shot


## called once by EnemyTargetApplier right after this entity spawns, with the targets alive at that moment
func set_attack_targets(player_target: ControllableEntity, base_target: Base) -> void:
	_player_target = player_target
	_base_target = base_target


## stops the entity where it is, as if it had reached its target
func stop_moving() -> void:
	# we move the target to where we are
	_navigation_agent.set_target_position(owner_controllable_entity.global_position)


## aims at the player if it is in sight and returns true; otherwise it does nothing and returns false
func try_attack_player() -> bool:
	# the player has to be in range and in direct line of sight
	var can_attack : bool = _can_attack_player()
	if can_attack:
		_current_attack_target = _player_target
	return can_attack


## aims at the base if it is in sight and returns true; otherwise it does nothing and returns false
func try_attack_base() -> bool:
	# the base has to be in range and in direct line of sight
	var can_attack : bool = _can_attack_base()
	if can_attack:
		_current_attack_target = _base_target
	return can_attack


## freezes the look-at angle where it was aiming, so the entity doesn't turn while it fires
func stop_aiming() -> void:
	_current_attack_target = null


## this will help us take a random point inside navigation mesh
func set_random_target_position() -> void:
	# back to wandering, so the look-at angle should follow movement again
	_current_attack_target = null
	# get a random point from the navigation region
	var random_target_position : Vector3 = _get_random_wander_target()
	# we set the new target destination position
	_navigation_agent.set_target_position(random_target_position)


## true if the player is close enough and in direct line of sight
func _can_attack_player() -> bool:
	# the player may have died since it was assigned
	return is_instance_valid(_player_target) and _attack_detector.has_detected_target(_player_target)


## true if the base is close enough and in direct line of sight
func _can_attack_base() -> bool:
	# the base may have been destroyed since it was assigned
	return is_instance_valid(_base_target) and _attack_detector.has_detected_target(_base_target)


## picks a random point on the navigation map; the state chart gives up on it if it can't be reached
func _get_random_wander_target() -> Vector3:
	# the agent joins the world's navigation map when it enters the tree
	return NavigationServer3D.map_get_random_point(
			_navigation_agent.get_navigation_map(),
			_navigation_agent.navigation_layers,
			false)


## the entity only turns toward its movement direction while it hasn't reached the target
func _can_aim() -> bool:
	return not _navigation_agent.is_target_reached()


## the avoidance computed a safe velocity; the entity applies its own speed to the direction
func _on_navigation_agent_velocity_computed(safe_velocity: Vector3) -> void:
	_safe_move_direction = safe_velocity.normalized()


## a grenade was picked up: this enemy eliminates itself
func _on_grenade_picked_up_handler(_event_context: Variant = null) -> void:
	owner_controllable_entity.eliminate()


## a new player instance spawned (ex: after a respawn): it becomes the player target
func _on_player_spawned_handler(player: ControllableEntity) -> void:
	_player_target = player
