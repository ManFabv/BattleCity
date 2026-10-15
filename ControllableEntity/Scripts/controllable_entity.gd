class_name ControllableEntity
extends CharacterBody3D

## emitted when this entity dies: health depleted or eliminated (ex: grenade, fall into the kill zone)
signal _entity_died

@export_group("Controller")
## decides where this entity moves, looks and when it shoots (player input or AI)
@export var _entity_controller : EntityControllerInterface

@export_group("References")
## system that will handle all the shooting logic
@export var _weapon_system: WeaponSystem
## manages the entity stats and its modifiers
@export var _entity_stats_manager : EntityStatsManager
## manages the health for the entity
@export var _health : Health

## the entity current stats (base level stats with active modifiers)
var _current_entity_stats : EntityStats:
	get():
		return _entity_stats_manager.resulting_entity_stats()


## we listen to the health running out
func _ready() -> void:
	# we die when the health runs out
	_health.subscribe_to_depleted(_on_health_depleted)


## moves, rotates and shoots following the controller, on the tick that consumes its input
func _physics_process(delta: float) -> void:
	# we accelerate the floor velocity towards the controller intention
	_apply_movement(delta)
	# we pull the body down while it's in the air
	_try_apply_gravity(delta)
	# we shoot while the shoot input is pressed
	_try_shot()
	# we rotate towards the controller look at angle
	_apply_rotation(delta)
	# we move the object with that velocity
	move_and_slide()


## kills this entity right away, whatever its health (ex: grenade, kill zone)
func eliminate() -> void:
	_die()


## public entry point so external systems (ex: pickups) can apply a stat modifier to this entity
func apply_stat_modifier(modifier: EntityStatsModifierInterface) -> void:
	_entity_stats_manager.add_modifier(modifier)


## the entity move speed shorthand access
func get_entity_move_speed() -> float:
	return _current_entity_stats.move_speed


## the entity controller shorthand access
func get_entity_controller() -> EntityControllerInterface:
	return _entity_controller


## accelerates the floor velocity towards the controller intention, read on the tick that consumes it
func _apply_movement(delta: float) -> void:
	var target_velocity : Vector3 = _entity_controller.get_move_direction() * get_entity_move_speed()
	# the vertical velocity is kept for the gravity, so only the floor plane accelerates
	target_velocity.y = velocity.y
	# reaching move_speed takes move_acceleration_time_seconds
	var acceleration : float = get_entity_move_speed() / _current_entity_stats.move_acceleration_time_seconds
	# each tick the velocity can change by the acceleration during that tick
	velocity = velocity.move_toward(target_velocity, acceleration * delta)


## rotates the body towards the controller look at angle, at the rotation speed of the stats
func _apply_rotation(delta: float) -> void:
	# the angle the body can turn during this tick
	var desired_rotation : float = _current_entity_stats.rotation_speed
	# we turn towards the desired angle without passing it
	rotation.y = rotate_toward(rotation.y, _entity_controller.get_look_at_angle(), desired_rotation * delta)


## pulls the body down only while it's in the air, the velocity it already has comes from velocity.y
func _try_apply_gravity(delta: float) -> void:
	# we only pull the body down while it's in the air
	if not is_on_floor():
		velocity += get_gravity() * _current_entity_stats.gravity_modifier * delta


## asks the weapon system to shoot only while the shoot input is pressed
func _try_shot() -> void:
	# we only ask the weapon system to shoot while the shoot input is pressed
	if _entity_controller.is_shot_pressed():
		_weapon_system.try_shot()


## notifies the death and removes the entity at the end of the frame
func _die() -> void:
	# TODO: spawn particles or play a sound before removing the node
	_entity_died.emit()
	# we remove the entity once the frame ends
	queue_free()


## listeners are notified once, since the entity is freed right after dying
func subscribe_to_death(on_death: Callable) -> void:
	_entity_died.connect(on_death, CONNECT_ONE_SHOT)


## called when the health runs out, which means this entity dies
func _on_health_depleted() -> void:
	_die()
