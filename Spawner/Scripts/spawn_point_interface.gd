## this is only an interface for the different spawn points
class_name SpawnPointInterface
extends Node3D


func spawn() -> void:
	push_error("spawn() should be implemented on inherited classes")
