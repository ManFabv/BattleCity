extends Node
class_name NormalStateMachine

@export_group("References")
## the entity controller reference
@export var _ai_controller : AIController
## the navigation agent that reports when a wander target is reached
@export var _navigation_agent : NavigationAgent3D
## the weapon system that reports when a shot was fired
@export var _weapon_system : WeaponSystem

@export_group("Behavior")
## relative chance of wandering after firing (no hace falta que sumen 1 ni 100)
@export var _wander_weight : float = 1.0
## relative chance of moving toward the player after firing
@export var _attack_player_weight : float = 1.0
## relative chance of moving toward the base after firing
@export var _attack_base_weight : float = 1.0
## how long, after attacking, the entity is forced to wander before it can attack again
@export var _attack_cooldown_seconds : float = 10.0

## the entity state chart for triggering state events
@onready var state_chart: StateChart = %"StateChart"

## timer context used to keep track of the post-attack cooldown
var _attack_cooldown_timer_context : CustomTimerContext
## true while the entity is still cooling down from a previous attack
var _is_attack_on_cooldown : bool = false


## to avoid having to connect these signals on every entity,
## we connect them here
func _ready() -> void:
	_navigation_agent.target_reached.connect(_on_navigation_agent_3d_target_reached)
	_weapon_system.shot_fired.connect(_on_weapon_system_shot_fired)
	_attack_cooldown_timer_context = CustomTimerContext.create_manual(_attack_cooldown_seconds, _on_attack_cooldown_timeout, tree_exited, false)
	CustomTimerContext.request(_attack_cooldown_timer_context)


func _on_wander_state_entered() -> void:
	_ai_controller.set_random_target_position()


func _on_fire_state_entered() -> void:
	_ai_controller.start_shooting()


func _on_attack_player_state_entered() -> void:
	_ai_controller.attack_player()
	_start_attack_cooldown()


func _on_attack_base_state_entered() -> void:
	_ai_controller.attack_base()
	_start_attack_cooldown()


func _on_navigation_agent_3d_target_reached() -> void:
	state_chart.send_event("fire_event")


func _on_weapon_system_shot_fired() -> void:
	_ai_controller.stop_shooting()
	state_chart.send_event(_pick_next_event())


## simple weighted random pick between wandering and attacking one of the two targets
## forces wander while the attack cooldown is active or no target is nearby/visible
func _pick_next_event() -> StringName:
	if _is_attack_on_cooldown:
		return &"wander_event"
	# only weigh in attack options that are actually reachable right now
	var player_weight : float = _attack_player_weight if _ai_controller.can_attack_player() else 0.0
	var base_weight : float = _attack_base_weight if _ai_controller.can_attack_base() else 0.0
	if player_weight <= 0.0 and base_weight <= 0.0:
		return &"wander_event"
	var total_weight : float = _wander_weight + player_weight + base_weight
	var roll : float = randf() * total_weight
	if roll < _wander_weight:
		return &"wander_event"
	elif roll < _wander_weight + player_weight:
		return &"attack_player_event"
	return &"attack_base_event"


## marks the entity as cooling down and (re)starts the cooldown timer
func _start_attack_cooldown() -> void:
	_is_attack_on_cooldown = true
	_attack_cooldown_timer_context.restart_requested.emit(_attack_cooldown_seconds)


## called when the post-attack cooldown timer times out
func _on_attack_cooldown_timeout() -> void:
	_is_attack_on_cooldown = false
