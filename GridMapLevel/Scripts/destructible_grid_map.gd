class_name DestructibleGridMap
extends GridMap

@export_group("Events")
## event emitted whenever a block is removed from this grid
@export var _on_block_destroyed : BaseEvent


## destroys the block owned by the shape we hit, the physics server tells us which cell that shape is
func destroy_block_from_shape(body_rid: RID, body_shape_index: int) -> void:
	# we resolve the cell that owns the shape
	var cell : Vector3i = _get_cell_from_shape(body_rid, body_shape_index)
	# we cache the item cell id
	var item_cell : int = get_cell_item(cell)
	# if we have a valid cell, so we destroy it
	if item_cell != GridMap.INVALID_CELL_ITEM:
		_destroy_block(cell)


## we mark the cell as destroyed and emit the signal to notify the listeners
func _destroy_block(cell: Vector3i) -> void:
	# mark the cell as destroyed
	set_cell_item(cell, GridMap.INVALID_CELL_ITEM)
	# we notify listeners
	_on_block_destroyed.emit(cell)


## cell of the given shape of this grid's physics body
func _get_cell_from_shape(body_rid: RID, body_shape_index: int) -> Vector3i:
	# the physics server gives us the transform of that shape relative to the grid body
	var shape_transform : Transform3D = PhysicsServer3D.body_get_shape_transform(body_rid, body_shape_index)
	# we convert the shape's position (local to the grid) into its grid cell coordinates
	return local_to_map(shape_transform.origin)
