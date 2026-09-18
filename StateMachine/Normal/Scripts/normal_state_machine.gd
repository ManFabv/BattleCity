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
## how long, after attacking, the entity is forced to wander before it can attack again
@export var _attack_cooldown_seconds : float = 10.0

## the entity state chart for triggering state events
@onready var state_chart: StateChart = %"StateChart"

## timer context used to keep track of the post-attack cooldown
var _attack_cooldown_timer_context : CustomTimerContext
## true while the entity is still cooling down from a previous attack
var _is_attack_on_cooldown : bool = false
## true while the upcoming shot is aimed at the player or the base instead of being a wander shot
var _is_aiming_at_target : bool = false


## to avoid having to connect these signals on every entity,
## we connect them here
func _ready() -> void:
	_navigation_agent.target_reached.connect(_on_navigation_agent_3d_target_reached)
	_weapon_system.subscribe_to_shot_fired(_on_weapon_system_shot_fired)
	_attack_cooldown_timer_context = CustomTimerContext.create_manual(_attack_cooldown_seconds, _on_attack_cooldown_timeout, tree_exited, false)
	CustomTimerContext.request(_attack_cooldown_timer_context)


func _on_wander_state_entered() -> void:
	_is_aiming_at_target = false
	_ai_controller.set_random_target_position()


func _on_fire_state_entered() -> void:
	_ai_controller.start_shooting()


func _on_attack_player_state_entered() -> void:
	_is_aiming_at_target = true
	_ai_controller.attack_player()


func _on_attack_base_state_entered() -> void:
	_is_aiming_at_target = true
	_ai_controller.attack_base()


func _on_navigation_agent_3d_target_reached() -> void:
	state_chart.send_event("fire_event")


func _on_weapon_system_shot_fired() -> void:
	_ai_controller.stop_shooting()
	state_chart.send_event(_next_event_after_shot())


## an aimed shot always (re)starts the cooldown and goes back to wandering; a wander shot
## only looks for a target once the cooldown from a previous attack has ended
func _next_event_after_shot() -> StringName:
	if _is_aiming_at_target:
		_start_attack_cooldown()
		return &"wander_event"
	if _is_attack_on_cooldown:
		return &"wander_event"
	if _ai_controller.can_attack_player():
		return &"attack_player_event"
	if _ai_controller.can_attack_base():
		return &"attack_base_event"
	return &"wander_event"


## marks the entity as cooling down and (re)starts the cooldown timer
func _start_attack_cooldown() -> void:
	_is_attack_on_cooldown = true
	_attack_cooldown_timer_context.restart_requested.emit(_attack_cooldown_seconds)


## called when the post-attack cooldown timer times out
func _on_attack_cooldown_timeout() -> void:
	_is_attack_on_cooldown = false
