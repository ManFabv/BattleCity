class_name EntityVisionDetector
extends TargetDetector

@export_group("Attack Detection")
## max distance at which the player or base is considered a valid attack target
@export var _detection_range : float = 12.0
## full vision cone width, centered on the entity's forward direction
@export var _vision_angle_degrees : float = 90.0
## used to sweep for obstacles between the entity and its target
@export var _vision_shape_cast : ShapeCast3D


## checks distance and a shapecast sweep toward the target to know if it's a valid attack target
func has_line_of_sight(target: Node3D) -> bool:
	if not is_instance_valid(target):
		return false
	var origin : Vector3 = owner_controllable_entity.global_position
	var target_position : Vector3 = target.global_position
	if origin.distance_to(target_position) > _detection_range:
		return false
	_vision_shape_cast.target_position = _vision_shape_cast.to_local(target_position)
	_vision_shape_cast.force_shapecast_update()
	# no collisions means a clear line of sight
	return _vision_shape_cast.get_collision_count() == 0
