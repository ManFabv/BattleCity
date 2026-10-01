class_name TargetDetectorInterface
extends Node3D

@export_group("References")
## who is the entity we are checking detection for
@export var owner_controllable_entity : ControllableEntity


func has_detected_target(_target: Node3D) -> bool:
	push_error("has_line_of_sight() should be implemented on inherited classes")
	return false
