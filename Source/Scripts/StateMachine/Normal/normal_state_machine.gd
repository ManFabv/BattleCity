extends Node
class_name NormalStateMachine

@export_group("References")
## the entity controller reference
@export var _ai_controller : AIController
## the navigation agent that reports when a wander target is reached
@export var _navigation_agent : NavigationAgent3D
## the weapon system that reports when a shot was fired
@export var _weapon_system : WeaponSystem

## the entity state chart for triggering state events
@onready var state_chart: StateChart = %"StateChart"


## to avoid having to connect these signals on every entity,
## we connect them here
func _ready() -> void:
	_navigation_agent.target_reached.connect(_on_navigation_agent_3d_target_reached)
	_weapon_system.shot_fired.connect(_on_weapon_system_shot_fired)


func _on_wander_state_entered() -> void:
	_ai_controller.set_random_target_position()


func _on_fire_state_entered() -> void:
	_ai_controller.start_shooting()


func _on_navigation_agent_3d_target_reached() -> void:
	state_chart.send_event("fire_event")


func _on_weapon_system_shot_fired() -> void:
	_ai_controller.stop_shooting()
	state_chart.send_event("wander_event")
