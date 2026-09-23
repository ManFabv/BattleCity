class_name ControllableEntity
extends CharacterBody3D

## emitted after the current level's stats are applied
signal entity_stats_set
## emitted when this entity runs out of health
signal entity_died

@export_group("Events")
@export var _on_input_changed_event : BaseEvent
@export var _on_menu_opened_event : BaseEvent

@export_group("Controller")
## this will give us the reference to the needed implementation
## which will make this entity move
@export var _entity_controller : EntityController

## generic accessor for this entity's controller
var entity_controller : EntityController:
	get():
		return _entity_controller

@export_group("Entity")
## per-level stats, health and weapon config
@export var _entity_levels : EntityLevelsConfig

#system that will handle all the shooting logic
@onready var _weapon_system: WeaponSystem = %WeaponSystem
## manages the entity stats and its modifiers
@onready var _entity_stats_manager : EntityStatsManager = %EntityStatsManager
## manages the health for the entity
@onready var _health : Health = %Health
## the tank's hull mesh
@onready var _body : MeshInstance3D = %Body
## the tank's turret mesh
@onready var _turret : MeshInstance3D = %Turret

#calculated velocity by input
var _move_velocity : Vector3 = Vector3.ZERO
#input intention captured during the render frame
var _input_move_direction : Vector3 = Vector3.ZERO
var _input_look_at_angle : float = 0.0
var _input_has_shot : bool = false

# the entity stats shorthand access
var _entity_stats : EntityStats:
	get():
		return _entity_stats_manager.entity_stats()

# the entity move speed shorthand access
var entity_move_speed : float:
	get():
		return _entity_stats.move_speed


func _ready() -> void:
	set_level(0)
	#we set the callbacks for the healths
	_health.subscribe_to_health_signals(_on_health_changed, _on_dead)
	#we listen to the input type changed signal on input manager
	_on_input_changed_event.subscribe(_entity_controller.on_input_type_changed, tree_exited)
	#we listen to the event signal when the menu is opened
	_on_menu_opened_event.subscribe(_entity_controller.on_menu_opened, tree_exited)


## public entry point so external systems (ex: pickups) can apply a stat modifier to this entity
func apply_stat_modifier(modifier: EntityStatsModifier) -> void:
	_entity_stats_manager.add_modifier(modifier)


## used by the tank shield power-up
func apply_shield(duration: float) -> void:
	_health.activate_shield(duration)


## applies speed, health and weapon for the given level in one call
func set_level(level: int) -> void:
	_entity_levels.current_index = level
	var entity_level: EntityLevelConfig = _entity_levels.current_level()
	_entity_stats_manager.configure(entity_level.entity_stats)
	_health.configure(entity_level.health_stats)
	_weapon_system.change_weapon(entity_level.weapon_config)
	_apply_entity_color(entity_level.entity_color)
	# notify that the correct entity stats are now set
	entity_stats_set.emit()


## tints the body and turret; duplicates the material first since it's a sub-resource
## shared by every instance of this scene (same reasoning as EntityStatsManager._apply_modifiers())
func _apply_entity_color(color: Color) -> void:
	_tint_mesh(_body, color)
	_tint_mesh(_turret, color)


func _tint_mesh(mesh_instance: MeshInstance3D, color: Color) -> void:
	var material : StandardMaterial3D = (mesh_instance.get_surface_override_material(0) as StandardMaterial3D).duplicate()
	material.albedo_color = color
	mesh_instance.set_surface_override_material(0, material)


## advances to the next entity level, if there is one (used by the star power-up)
func level_up() -> void:
	set_level(_entity_levels.current_index + 1)


## resets weapon and entity stats back to the starting level,
## clearing any active stat modifiers (e.g. after the player dies)
func reset_stats() -> void:
	_entity_stats_manager.clear_modifiers()
	set_level(0)


## kills this entity immediately, same exit path as running out of health
## (used by the grenade power-up)
func eliminate() -> void:
	_on_dead()


func _process(_delta) -> void:
	# we capture the input intention for the next physics step
	_input_move_direction = _entity_controller.get_move_direction()
	_input_look_at_angle = _entity_controller.get_look_at_angle()
	_input_has_shot = _entity_controller.is_shot_pressed()


func _physics_process(delta) -> void:
	# we calculate a desired velocity
	var target_velocity : Vector3 = _input_move_direction * entity_move_speed
	# we apply gravity to the body
	var applied_gravity : float = _process_gravity()
	# eliminate the entity if it fell below the level's death Z position
	if _check_z_death():
		eliminate()
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


func _process_gravity() -> float:
	var applied_gravity : float = 0.0
	# if we are falling, we make a sum of the velocity on Y and applying gravity
	if not is_on_floor():
		applied_gravity = _move_velocity.y - _entity_stats.gravity
	# we return the correct gravity
	return applied_gravity


func _check_z_death() -> bool:
	return global_position.y < _entity_stats.death_vertical_position


## called everytime the health changes, healing or damaging
func _on_health_changed(_health_stats: HealthStats, _current_health: float) -> void:
	# TODO: this should be connected to the UI to see visually the health
	pass


## called when the entity has no health
func _on_dead() -> void:
	# TODO: we need a better implementation for this method
	# like spawning particles or playing sounds before
	# removing the node
	entity_died.emit()
	queue_free()


## listeners are notified once, since the entity is freed right after dying
func subscribe_to_death(on_death: Callable) -> void:
	entity_died.connect(on_death, CONNECT_ONE_SHOT)
