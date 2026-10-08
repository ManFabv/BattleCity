class_name ControllableEntity
extends CharacterBody3D

## emitted when this entity runs out of health
signal _entity_died

@export_group("Controller")
## this will give us the reference to the needed implementation
## which will make this entity move
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

## calculated velocity by input
var _move_velocity : Vector3 = Vector3.ZERO
## input intention captured during the process method
var _input_move_direction : Vector3 = Vector3.ZERO
## look at intention captured during the process method
var _input_look_at_angle : float = 0.0
## shooting intention captured during the process method
var _input_has_shot : bool = false

## the entity current stats (base level stats with active modifiers)
var _current_entity_stats : EntityStats:
	get():
		return _entity_stats_manager.resulting_entity_stats()


func _ready() -> void:
	# we ask the level manager to configure this entity, the children are ready by now
	_entity_level_manager.configure_entity_for_current_level()
	#we set the callbacks for the healths
	_health.subscribe_to_depleted(_on_health_depleted)


func _process(_delta) -> void:
	# we capture the input intention for the next physics step
	_input_move_direction = _entity_controller.get_move_direction()
	_input_look_at_angle = _entity_controller.get_look_at_angle()
	_input_has_shot = _entity_controller.is_shot_pressed()


func _physics_process(delta) -> void:
	# we calculate a desired velocity
	var target_velocity : Vector3 = _input_move_direction * get_entity_move_speed()
	# we apply gravity to the body
	var applied_gravity : float = _process_gravity()
	# the max velocity change allowed this tick: reaching move_speed takes move_acceleration_time_seconds
	var max_velocity_change_this_tick : float = (get_entity_move_speed() / _current_entity_stats.move_acceleration_time_seconds) * delta
	var current_velocity_on_floor : Vector3 = Vector3(velocity.x, 0.0, velocity.z)
	var target_velocity_xon_floor : Vector3 = Vector3(target_velocity.x, 0.0, target_velocity.z)
	# moving the vector as a whole keeps the diagonal ramps in a straight line
	var new_velocity_on_floor : Vector3 = current_velocity_on_floor.move_toward(target_velocity_xon_floor, max_velocity_change_this_tick)
	_move_velocity.x = new_velocity_on_floor.x
	_move_velocity.y = velocity.y - applied_gravity * delta
	_move_velocity.z = new_velocity_on_floor.z
	# we calculate the angle for the current position to view to the desired point
	var look_at_angle : float = rotate_toward(rotation.y, _input_look_at_angle, _current_entity_stats.rotation_speed * delta)
	# we only ask the weapon system to shoot while the shoot input is pressed
	if _input_has_shot:
		_weapon_system.try_shot()
	# we update the velocity according to the calculated movement
	velocity = _move_velocity
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


## kills this entity and triggers the signal for that
func eliminate() -> void:
	_on_health_depleted()


## public entry point so external systems (ex: pickups) can apply a stat modifier to this entity
func apply_stat_modifier(modifier: EntityStatsModifierInterface) -> void:
	_entity_stats_manager.add_modifier(modifier)


## public entry point so external systems (ex: pickups) can attach an upgrade to this entity
func attach_upgrade(upgrade: Node3D) -> void:
	_upgrade_attach_point.attach_upgrade(upgrade)


## the entity move speed shorthand access
func get_entity_move_speed() -> float:
	return _current_entity_stats.move_speed


## the entity controller shorthand access
func get_entity_controller() -> EntityControllerInterface:
	return _entity_controller


## gravity to apply this physics step, zero while on the floor
func _process_gravity() -> float:
	var applied_gravity : float = 0.0
	# we only pull the body down while it's in the air, the velocity it already has comes from velocity.y
	if not is_on_floor():
		applied_gravity = _current_entity_stats.gravity
	# we return the correct gravity
	return applied_gravity


## if we are falling from the ground, we make sure to trigger a dead
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
