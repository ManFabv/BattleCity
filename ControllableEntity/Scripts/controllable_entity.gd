class_name ControllableEntity
extends CharacterBody3D

## emitted after the configuration of the current level is applied (stats, health, weapon and color)
signal entity_configured_for_level
## emitted when this entity runs out of health
signal entity_died

@export_group("Events")
@export var _on_input_changed_event : BaseEvent
@export var _on_menu_opened_event : BaseEvent

@export_group("Controller")
## this will give us the reference to the needed implementation
## which will make this entity move
@export var _entity_controller : EntityControllerInterface

@export_group("Upgrades")
## where attachable upgrades (ex: shields) are parented, so they follow this entity
@export var _upgrade_attach_point : UpgradeAttachPoint

@export_group("Entity")
## per-level stats, health and weapon config
@export var _entity_levels : EntityLevels

## system that will handle all the shooting logic
@onready var _weapon_system: WeaponSystem = %WeaponSystem
## manages the entity stats and its modifiers
@onready var _entity_stats_manager : EntityStatsManager = %EntityStatsManager
## manages the health for the entity
@onready var _health : Health = %Health
## the tank's body mesh
@onready var _tintable_body_mesh : TintedMesh = %TintableMeshBody

## calculated velocity by input
var _move_velocity : Vector3 = Vector3.ZERO
## input intention captured during the process method
var _input_move_direction : Vector3 = Vector3.ZERO
## look at intention captured during the process method
var _input_look_at_angle : float = 0.0
## shooting intention captured during the process method
var _input_has_shot : bool = false

## index of the currently applied level, clamped to the levels that exist
var _current_level_index : int = 0:
	set(new_value):
		# we clamp the index so it always points to an existing level
		_current_level_index = clampi(new_value, 0, _entity_levels.last_index())

## the entity stats shorthand access
var _entity_stats : EntityStats:
	get():
		return _entity_stats_manager.resulting_entity_stats()


func _ready() -> void:
	# we hand the children the archetype values first, they don't change with the level
	_configure_entity_for_archetype()
	# we apply the current level
	_configure_entity_for_level(_current_level_index)
	#we set the callbacks for the healths
	_health.subscribe_to_health_signals(_on_health_changed, _on_dead)
	#we listen to the input type changed signal on input manager
	_on_input_changed_event.subscribe(_entity_controller.on_input_type_changed, tree_exited)
	#we listen to the event signal when the menu is opened
	_on_menu_opened_event.subscribe(_entity_controller.on_menu_opened, tree_exited)


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
	# we are incrementing the velocity to make it match the desired velocity
	_move_velocity.x = lerp(velocity.x, target_velocity.x, _entity_stats.move_damping * delta)
	_move_velocity.y += applied_gravity * delta
	_move_velocity.z = lerp(velocity.z, target_velocity.z, _entity_stats.move_damping * delta)
	# we calculate the angle for the current position to view to the desired point
	var look_at_angle : float = lerp_angle(rotation.y, _input_look_at_angle, _entity_stats.rotation_speed * delta)
	# we get if the player pressed shot input
	_weapon_system.try_shot(_input_has_shot)
	# we update the velocity according to the calculated movement
	velocity = _move_velocity
	# we rotate accordingly
	rotation.y = look_at_angle
	# we move the object with that velocity
	move_and_slide()
	# eliminate the entity if it fell below the level's death Z position
	_check_vertical_death()


## sets the level this entity starts with; only stores the index
func set_initial_level(level: int) -> void:
	_current_level_index = level


## advances to the next entity level, if there is one
func level_up() -> void:
	# already at the highest level: re-applying it would refill health and rebuild the weapon for nothing
	if not _is_at_max_level():
		_configure_entity_for_level(_current_level_index + 1)


## kills this entity and triggers the signal for that
func eliminate() -> void:
	_on_dead()


## public entry point so external systems (ex: pickups) can apply a stat modifier to this entity
func apply_stat_modifier(modifier: EntityStatsModifierInterface) -> void:
	_entity_stats_manager.add_modifier(modifier)


## public entry point so external systems (ex: pickups) can attach an upgrade to this entity
func attach_upgrade(upgrade: Node3D) -> void:
	_upgrade_attach_point.attach_upgrade(upgrade)


## the entity move speed shorthand access
func get_entity_move_speed() -> float:
	return _entity_stats.move_speed


## the entity controller shorthand access
func get_entity_controller() -> EntityControllerInterface:
	return _entity_controller


## hands the children the archetype values, the ones that don't change with the level
func _configure_entity_for_archetype() -> void:
	# exception to the no-concrete-cast rule: only enemies have an AIController, the player has nothing to configure here
	var ai_controller : AIController = _entity_controller as AIController
	if is_instance_valid(ai_controller):
		# we hand the AI the time it has to reach each wander target
		ai_controller.configure(_entity_levels.ai_wander_timeout_seconds)



## applies speed, health and weapon for the given level in one call
func _configure_entity_for_level(level: int) -> void:
	# we update the current level index, the setter clamps it
	_current_level_index = level
	# we cache the entity level config
	var entity_level_config: EntityLevelConfig = _entity_levels.level_at(_current_level_index)
	## we setup the stats manager
	_entity_stats_manager.configure(entity_level_config.entity_stats)
	## we setup the health
	_health.configure(entity_level_config.max_health_points)
	## we setup the weapon system
	_weapon_system.change_weapon(entity_level_config.weapon_config)
	## we setup the entity color
	_tintable_body_mesh.apply_color(entity_level_config.entity_color)
	# we notify that the correct entity configuration was made
	entity_configured_for_level.emit()


## we check if we are at the max level for this entity
func _is_at_max_level() -> bool:
	return _current_level_index >= _entity_levels.last_index()


func _process_gravity() -> float:
	var applied_gravity : float = 0.0
	# if we are falling, we make a sum of the velocity on Y and applying gravity
	if not is_on_floor():
		applied_gravity = _move_velocity.y - _entity_stats.gravity
	# we return the correct gravity
	return applied_gravity


## if we are falling from the ground, we make sure to trigger a dead
func _check_vertical_death() -> void:
	if global_position.y < _entity_stats.death_vertical_position:
		# eliminate the entity if it fell below the level's death Z position
		eliminate()


## listeners are notified once, since the entity is freed right after dying
func subscribe_to_death(on_death: Callable) -> void:
	entity_died.connect(on_death, CONNECT_ONE_SHOT)


## listeners are notified every time the level stats are applied
func subscribe_to_configured_for_level(on_configured_for_level: Callable) -> void:
	entity_configured_for_level.connect(on_configured_for_level)


## called everytime the health changes, healing or damaging
func _on_health_changed(_max_health_points: int, _current_health: int) -> void:
	# TODO: this should be connected to the UI to see visually the health
	pass


## called when the entity has no health
func _on_dead() -> void:
	# TODO: we need a better implementation for this method
	# like spawning particles or playing sounds before
	# removing the node
	entity_died.emit()
	queue_free()
