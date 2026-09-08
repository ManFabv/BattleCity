extends Node3D
class_name GameManager

@export var _initial_scene: PackedScene
@export var _timer_manager: PackedScene


func _ready() -> void:
	# TODO: here we should instantiate any global system
	var current_timer_manager : TimerManager = _timer_manager.instantiate() as TimerManager
	add_child(current_timer_manager)
	# TODO: we instantiate the initial screen until we
	# have an scene manager
	var current_scene : Node3D = _initial_scene.instantiate() as Node3D
	add_child(current_scene)
