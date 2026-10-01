class_name SpawnPointInterface
extends Node3D


func _ready() -> void:
	# deferred so every listener is subscribed no matter where this node sits in the tree
	spawn.call_deferred()


func spawn() -> void:
	push_error("spawn() should be implemented on inherited classes")
