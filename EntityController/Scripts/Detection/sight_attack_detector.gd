class_name SightAttackDetector
extends TargetDetectorInterface

@export_group("Attack Detection")
## max distance at which the player or base is considered a valid attack target
@export_range(0.1, 20.0) var _detection_range : float = 12.0
## used to sweep for obstacles between the entity and its target
@export var _vision_shape_cast : ShapeCast3D


## checks distance and a shapecast sweep toward the target to know if it's a valid attack target
func has_line_of_sight(target: Node3D) -> bool:
	# if the target is not valid, we return that we don't have a line of sight
	if not is_instance_valid(target):
		return false
	# we cache the target position
	var target_position : Vector3 = target.global_position
	# as a quick filter, if the target is out of range we exit early
	if not _is_target_in_range(target_position):
		return false
	# we now check if the shapecast is colliding with something that blocks the line of sight
	if _is_shape_cast_colliding(target_position):
		return false
	# if we get here, there isn't any collision blocking the line of sight
	return true


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
	# we check if we are collision with the grid map
	return _check_shape_cast_colliders()


## true if any shapecast collision blocks the line of sight, except level blocks that shots fly over (water)
func _check_shape_cast_colliders() -> bool:
	for i in range(_vision_shape_cast.get_collision_count()):
		# if we are not colliding with a grid map we continue to next collider
		if _vision_shape_cast.get_collider(i) is not GridMapLevelBlocks:
			# anything that is not the level grid (world geometry) always blocks
			return true
		# we get the grid map
		var level_grid : GridMapLevelBlocks = _vision_shape_cast.get_collider(i) as GridMapLevelBlocks
		# we get the RID
		var collider_rid : RID = _vision_shape_cast.get_collider_rid(i)
		# we get the shape ID
		var collider_shape_id : int = _vision_shape_cast.get_collider_shape(i)
		# we check if this grid map block is actually blocking and return the result
		if level_grid.blocks_projectiles_at_shape(collider_rid, collider_shape_id):
			return true
	# if we get to here, there isn't any collisions blocking the line of sight
	return false
