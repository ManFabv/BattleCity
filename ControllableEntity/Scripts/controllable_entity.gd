class_name ControllableEntity
extends CharacterBody3D

## emitted when this entity dies: health depleted, fall below the level or eliminated (ex: grenade)
signal _entity_died

@export_group("Controller")
## decides where this entity moves, looks and when it shoots (player input or AI)
@export var _entity_controller : EntityControllerInterface

@export_group("Upgrades")
## where attachable upgrades (ex: shields) are parented, so they follow this entity
@export var _upgrade_attach_point : UpgradeAttachPoint

@export_group("Entity")
## applies the level configuration (stats, health, weapon and color) and levels up this entity
@export var _entity_level_manager : EntityLevelManager

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


func _ready() -> void:
	# we ask the level manager to configure this entity, the children are ready by now
	_entity_level_manager.configure_entity_for_current_level()
	# we die when the health runs out
	_health.subscribe_to_depleted(_on_health_depleted)


func _physics_process(delta: float) -> void:
	# we read the controller intention on the same tick that consumes it
	var target_velocity : Vector3 = _entity_controller.get_move_direction() * get_entity_move_speed()
	# the max velocity change allowed this tick: reaching move_speed takes move_acceleration_time_seconds
	var max_velocity_change_this_tick : float = (get_entity_move_speed() / _current_entity_stats.move_acceleration_time_seconds) * delta
	var current_velocity_on_floor : Vector3 = Vector3(velocity.x, 0.0, velocity.z)
	var target_velocity_on_floor : Vector3 = Vector3(target_velocity.x, 0.0, target_velocity.z)
	# moving the vector as a whole keeps the diagonal ramps in a straight line
	var new_velocity_on_floor : Vector3 = current_velocity_on_floor.move_toward(target_velocity_on_floor, max_velocity_change_this_tick)
	# we update the floor velocity, the vertical one is kept for the gravity
	velocity.x = new_velocity_on_floor.x
	velocity.z = new_velocity_on_floor.z
	# we only pull the body down while it's in the air, the velocity it already has comes from velocity.y
	if not is_on_floor():
		velocity += get_gravity() * _current_entity_stats.gravity_modifier * delta
	# we calculate the angle for the current position to view to the desired point
	var look_at_angle : float = rotate_toward(rotation.y, _entity_controller.get_look_at_angle(), _current_entity_stats.rotation_speed * delta)
	# we only ask the weapon system to shoot while the shoot input is pressed
	if _entity_controller.is_shot_pressed():
		_weapon_system.try_shot()
	# we rotate accordingly
	rotation.y = look_at_angle
	# we move the object with that velocity
	move_and_slide()
	# we eliminate the entity if it fell below the level's vertical death position
	_check_vertical_death()


## sets the level this entity starts with; only stores the index
func set_initial_level(level: int) -> void:
	# we let the level manager store it, it works before the entity enters the tree
	_entity_level_manager.set_initial_level(level)


## advances to the next entity level, if there is one
func level_up() -> void:
	# we let the level manager decide if there is a next level
	_entity_level_manager.level_up()


## kills this entity right away, whatever its health (ex: grenade, fall)
func eliminate() -> void:
	_on_health_depleted()


## public entry point so external systems (ex: pickups) can apply a stat modifier to this entity
func apply_stat_modifier(modifier: EntityStatsModifierInterface) -> void:
	_entity_stats_manager.add_modifier(modifier)


## public entry point so external systems (ex: pickups) can attach an upgrade to this entity
func attach_upgrade(upgrade_scene: PackedScene) -> void:
	_upgrade_attach_point.attach_upgrade(upgrade_scene)


## the entity move speed shorthand access
func get_entity_move_speed() -> float:
	return _current_entity_stats.move_speed


## the entity controller shorthand access
func get_entity_controller() -> EntityControllerInterface:
	return _entity_controller


## eliminates the entity once it fell below the level (ex: knocked off the arena)
func _check_vertical_death() -> void:
	if global_position.y < _current_entity_stats.death_vertical_position:
		# eliminate the entity if it fell below the level's death vertical position
		eliminate()


## listeners are notified once, since the entity is freed right after dying
func subscribe_to_death(on_death: Callable) -> void:
	_entity_died.connect(on_death, CONNECT_ONE_SHOT)


## called when the health runs out, which means this entity dies
func _on_health_depleted() -> void:
	# TODO: we need a better implementation for this method
	# like spawning particles or playing sounds before
	# removing the node
	_entity_died.emit()
	queue_free()
