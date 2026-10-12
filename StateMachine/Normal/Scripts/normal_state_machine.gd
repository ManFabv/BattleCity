class_name NormalStateMachine
extends Node

## state chart events, as StringName so send_event() doesn't convert a String on every call
const _AIM_EVENT : StringName = &"aim_event"
const _WANDER_EVENT : StringName = &"wander_event"
## state chart expression property read by the wander timeout transition
const _WANDER_TIMEOUT_PROPERTY : StringName = &"wander_timeout_seconds"

@export_group("References")
## the entity controller reference
@export var _ai_controller : AIController
## the weapon system that reports when a shot was fired
@export var _weapon_system : WeaponSystem
## the entity state chart for triggering state events
@export var _state_chart : StateChart
@export_group("Wander Setup")
## seconds the entity has to reach the current wander target before giving up on it (unreachable point or blocked way)
@export_range(0.1, 20.0) var _wander_timeout_seconds : float = 10.0:
	set(new_value):
		# we prevent negative timeouts
		_wander_timeout_seconds = maxf(new_value, 0.0)
@export_group("Attack Setup")
## chance of preferring the player over the base when both are in sight
@export_range(0.0, 1.0) var _attack_player_chance : float = 0.8:
	set(new_value):
		# we keep the chance inside the probability range
		_attack_player_chance = clampf(new_value, 0.0, 1.0)


## we publish the wander timeout to the chart and subscribe to the weapon signal
func _ready() -> void:
	# the chart reads it when it enters Wander, so it has to exist before that
	_state_chart.set_expression_property(_WANDER_TIMEOUT_PROPERTY, _wander_timeout_seconds)
	# we listen to the shots of the equipped weapon
	_weapon_system.subscribe_to_shot_fired(_on_weapon_system_shot_fired)


## the entity picks a new random point to wander to
func _on_wander_state_entered() -> void:
	# we ask the controller for a new wander target
	_ai_controller.set_random_target_position()


## the entity stops and aims at the player or the base if one is in sight
func _on_aim_in_place_state_entered() -> void:
	# we stop where we are
	_ai_controller.stop_moving()
	# one roll decides which target is tried first, the other one is the fallback
	if randf() < _attack_player_chance:
		# the base is only tried when the player is not in sight
		if not _ai_controller.try_attack_player():
			_ai_controller.try_attack_base()
	else:
		# the player is only tried when the base is not in sight
		if not _ai_controller.try_attack_base():
			_ai_controller.try_attack_player()


## the entity holds its aim and shoots
func _on_fire_state_entered() -> void:
	# we stop tracking the target so the entity holds its aim instead of still turning while it shoots
	_ai_controller.stop_aiming()
	_ai_controller.start_shooting()


## the wander target was reached, so the entity aims
func _on_navigation_agent_target_reached() -> void:
	# we send the aim event to the chart
	_state_chart.send_event(_AIM_EVENT)


## the shot was fired, so the entity releases the trigger and goes back to wandering
func _on_weapon_system_shot_fired() -> void:
	# we release the trigger
	_ai_controller.stop_shooting()
	# we go back to wandering
	_state_chart.send_event(_WANDER_EVENT)
