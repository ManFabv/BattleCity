class_name SightAttackDetector
extends Node3D

@export_group("References")
## who is the entity we are checking detection for
@export var _owner_controllable_entity : ControllableEntity
@export_group("Attack Detection")
## max distance at which the player or base is considered a valid attack target
@export_range(0.1, 20.0) var _detection_range : float = 12.0:
	set(new_value):
		# we prevent negative ranges
		_detection_range = maxf(new_value, 0.0)
## used to sweep for obstacles between the entity and its target
@export var _vision_shape_cast : ShapeCast3D


## checks distance and a shapecast sweep toward the target to know if it's a valid attack target;
## the caller makes sure the target is still valid
func has_detected_target(target: Node3D) -> bool:
	# we cache the target position
	var target_position : Vector3 = target.global_position
	# as a quick filter, if the target is out of range we exit early
	if not _is_target_in_range(target_position):
		return false
	# the target is detected if nothing blocks the line of sight
	return not _is_shape_cast_colliding(target_position)


## true if the given world position is within the detection range of the owner entity
func _is_target_in_range(target_position: Vector3) -> bool:
	# the origin is the same point the shapecast sweeps from
	var origin : Vector3 = _owner_controllable_entity.global_position
	# we compare that the target is inside a certain range
	return origin.distance_to(target_position) <= _detection_range


## checks the shapecast toward the given world position
func _is_shape_cast_colliding(target_position: Vector3) -> bool:
	# we set the shape cast target position
	_vision_shape_cast.target_position = _vision_shape_cast.to_local(target_position)
	# we update to see if there any collision
	_vision_shape_cast.force_shapecast_update()
	# the mask only includes things that block sight, so any collision blocks it
	return _vision_shape_cast.is_colliding()
