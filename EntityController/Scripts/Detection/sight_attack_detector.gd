class_name SightAttackDetector
extends TargetDetectorInterface

@export_group("Attack Detection")
## max distance at which the player or base is considered a valid attack target
@export_range(0.1, 20.0) var _detection_range : float = 12.0
## used to sweep for obstacles between the entity and its target
@export var _vision_shape_cast : ShapeCast3D


## checks distance and a shapecast sweep toward the target to know if it's a valid attack target
func has_detected_target(target: Node3D) -> bool:
	# if the target is not valid, we return that we don't have a line of sight
	if not is_instance_valid(target):
		return false
	# we cache the target position
	var target_position : Vector3 = target.global_position
	# as a quick filter, if the target is out of range we exit early
	if not _is_target_in_range(target_position):
		return false
	# we now check if the shapecast isn't colliding with something that blocks the line of sight
	if not _is_shape_cast_colliding(target_position):
		return true
	# if we get here, there is a collision blocking the line of sight
	return false


## true if the given world position is within the detection range of the owner entity
func _is_target_in_range(target_position: Vector3) -> bool:
	# the origin is the same point the shapecast sweeps from
	var origin : Vector3 = owner_controllable_entity.global_position
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
