class_name NormalStateMachine
extends Node

## state chart events, as StringName so send_event() doesn't convert a String on every call
const _FIRE_EVENT : StringName = &"fire_event"
const _WANDER_EVENT : StringName = &"wander_event"
const _ATTACK_PLAYER_EVENT : StringName = &"attack_player_event"
const _ATTACK_BASE_EVENT : StringName = &"attack_base_event"

@export_group("References")
## the entity controller reference
@export var _ai_controller : AIController
## the weapon system that reports when a shot was fired
@export var _weapon_system : WeaponSystem
## the entity state chart for triggering state events
@export var _state_chart : StateChart

## true while the upcoming shot is aimed at the player or the base instead of being a wander shot
var _is_aiming_at_target : bool = false


## we subscribe to the controller and weapon signals, exposed through their subscribe methods
func _ready() -> void:
	_ai_controller.subscribe_to_wander_timed_out(_on_ai_controller_wander_timed_out)
	_weapon_system.subscribe_to_shot_fired(_on_weapon_system_shot_fired)


## an aimed shot always goes back to wandering; a wander shot looks for a target to attack
func _next_event_after_shot() -> StringName:
	if _is_aiming_at_target:
		return _WANDER_EVENT
	if _ai_controller.can_attack_player():
		return _ATTACK_PLAYER_EVENT
	if _ai_controller.can_attack_base():
		return _ATTACK_BASE_EVENT
	return _WANDER_EVENT


## the entity picks a new random point to wander to
func _on_wander_state_entered() -> void:
	_is_aiming_at_target = false
	_ai_controller.set_random_target_position()


## the entity holds its aim and shoots
func _on_fire_state_entered() -> void:
	# we stop tracking the target so the entity holds its aim instead of still turning while it shoots
	_ai_controller.stop_aiming()
	_ai_controller.start_shooting()


## the entity aims at the player before shooting
func _on_attack_player_state_entered() -> void:
	_is_aiming_at_target = true
	_ai_controller.attack_player()


## the entity aims at the base before shooting
func _on_attack_base_state_entered() -> void:
	_is_aiming_at_target = true
	_ai_controller.attack_base()


## the wander target was reached, so the entity shoots
func _on_navigation_agent_target_reached() -> void:
	_state_chart.send_event(_FIRE_EVENT)


## the wander target took too long to reach, so the entity shoots as if it had reached it
func _on_ai_controller_wander_timed_out() -> void:
	_state_chart.send_event(_FIRE_EVENT)


## the shot was fired, so the entity releases the trigger and picks what to do next
func _on_weapon_system_shot_fired() -> void:
	_ai_controller.stop_shooting()
	_state_chart.send_event(_next_event_after_shot())
