extends Node
class_name NormalStateMachine

## the entity controller reference
@export var _ai_controller : AIController

## the entity state chart for triggering state events
@onready var state_chart: StateChart = %"StateChart"


func _on_wander_state_entered() -> void:
	_ai_controller.set_random_target_position()


func _on_fire_state_entered() -> void:
	_ai_controller.start_shooting()


func _on_navigation_agent_3d_target_reached() -> void:
	state_chart.send_event("fire_event")


func _on_weapon_system_shot_fired() -> void:
	_ai_controller.stop_shooting()
	state_chart.send_event("wander_event")
