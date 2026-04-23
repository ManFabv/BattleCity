extends Node3D
class_name GameManager

@export var _initial_scene: PackedScene


func _ready() -> void:
	# TODO: we instantiate the initial screen until we
	# have an scene manager
	var current_scene : Node3D = _initial_scene.instantiate() as Node3D
	add_child(current_scene)
