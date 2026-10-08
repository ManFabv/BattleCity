class_name GameManager
extends Node3D

@export_group("Scenes")
## the first scene that we want to instantiate
@export var _initial_scene: PackedScene
## the scene that will handle the timers in the scene
@export var _timer_manager_scene: PackedScene


func _ready() -> void:
	# TODO: here we should instantiate any global system
	var current_timer_manager : CustomTimerManager = _timer_manager_scene.instantiate() as CustomTimerManager
	add_child(current_timer_manager)
	# TODO: we instantiate the initial screen until we have an scene manager
	var current_scene : Node3D = _initial_scene.instantiate() as Node3D
	add_child(current_scene)
