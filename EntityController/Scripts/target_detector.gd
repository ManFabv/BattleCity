class_name TargetDetector
extends Node

@export_group("References")
## who is the entity we are checking detection for
@export var owner_controllable_entity : ControllableEntity:
	set(new_value):
		owner_controllable_entity = new_value
	get():
		return owner_controllable_entity


func has_line_of_sight(_target: Node3D) -> bool:
	push_error("has_line_of_sight() should be implemented on inherited classes")
	return false
