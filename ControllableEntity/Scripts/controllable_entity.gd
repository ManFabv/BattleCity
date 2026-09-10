class_name ControllableEntity
extends CharacterBody3D

## This signal is emitted when the entity stats are set
signal entity_stats_set

@export_group("Events")
@export var _on_input_changed_event : BaseEvent
@export var _on_menu_opened_event : BaseEvent

@export_group("Controller")
## this will give us the reference to the needed implementation
## which will make this entity move
@export var _entity_controller : EntityController

#where we are going to spawn the projectile
@onready var _muzzle: Marker3D = %Muzzle
#system that will handle all the shooting logic
@onready var _weapon_system: WeaponSystem = %WeaponSystem
## manages the entity stats and its modifiers
@onready var _entity_stats_manager : EntityStatsManager = %EntityStatsManager
## manages the health for the entity
@onready var _health : Health = %Health

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
	#we set the callbacks for the healths
	_health.subscribe_to_health_signals(_on_health_changed, _on_dead)
	#we listen to the input type changed signal on input manager
	_on_input_changed_event.subscribe(_entity_controller.on_input_type_changed, tree_exited)
	#we listen to the event signal when the menu is opened
	_on_menu_opened_event.subscribe(_entity_controller.on_menu_opened, tree_exited)
	# emit a signal to notify that the correct entity stats is set
	entity_stats_set.emit()


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
	# we are incrementing the velocity to make it match the desired velocity
	_move_velocity.x = lerp(velocity.x, target_velocity.x, _entity_stats.move_damping * delta)
	_move_velocity.y += applied_gravity * delta
	_move_velocity.z = lerp(velocity.z, target_velocity.z, _entity_stats.move_damping * delta)
	# we calculate the angle for the current position to view to the desired point
	var look_at_angle : float = lerp_angle(rotation.y, _input_look_at_angle, _entity_stats.rotation_speed * delta)
	# we get if the player pressed shot input
	_weapon_system.try_shot(_input_has_shot, _muzzle)
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


## called everytime the health changes, healing or damaging
func _on_health_changed(_health_stats: HealthStats, _current_health: float) -> void:
	# TODO: this should be connected to the UI to see visually the health
	pass


## called when the entity has no health
func _on_dead() -> void:
	# TODO: we need a better implementation for this method
	# like spawning particles or playing sounds before 
	# removing the node
	queue_free()
