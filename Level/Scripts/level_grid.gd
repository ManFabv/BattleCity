class_name LevelGrid
extends GridMap

## block types placed on this grid, matched to cells by gridmap_item_id
@export var block_types: Array[BlockType] = []


## resolves a hit on this grid's physics body by asking the physics server which
## shape was actually touched: no position/direction guessing, so no ambiguity
## regardless of the angle or point of impact
func resolve_hit_from_shape(body_rid: RID, body_shape_index: int) -> void:
	var shape_transform := PhysicsServer3D.body_get_shape_transform(body_rid, body_shape_index)
	var cell := local_to_map(shape_transform.origin)
	var item := get_cell_item(cell)

	for block_type in block_types:
		if block_type.gridmap_item_id == item and block_type.is_destructible:
			set_cell_item(cell, GridMap.INVALID_CELL_ITEM)
