extends Resource
class_name ContinuousMovementStrategy


## We use a local copy because we don't want the resource to be shared 
## between different entities, we want each entity to have its own values
func _init() -> void:
	resource_local_to_scene = true


## here we can setup the strategy before use
func initialize(_origin: Node3D) -> void:
	push_error("initialize() should be implemented on inherited")


## function responsible for handling any continuous movement like projectiles
func update_movement(_delta: float, _transform_to_move: Transform3D) -> Transform3D:
	push_error("update_continuous_movement should be implemented on inherited")
	return _transform_to_move
