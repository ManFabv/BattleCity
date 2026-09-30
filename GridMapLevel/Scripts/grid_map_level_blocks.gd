class_name GridMapLevelBlocks
extends GridMap

## block types placed on this grid, matched to cells by gridmap_item_id
@export var block_types: Array[GridMapBlockType] = []
## event emitted whenever a destructible block is removed from this grid
@export var _on_block_destroyed : BaseEvent


## resolves a hit on this grid's physics body by asking the physics server which
## shape was actually touched: no position/direction guessing, so no ambiguity
## regardless of the angle or point of impact
## removes the block if it's destructible and returns true if it stops the projectile
func resolve_hit_from_shape(body_rid: RID, body_shape_index: int) -> bool:
	var cell := _get_cell_from_shape(body_rid, body_shape_index)
	var item := get_cell_item(cell)

	for block_type in block_types:
		if block_type.gridmap_item_id == item:
			if block_type.is_destructible:
				set_cell_item(cell, GridMap.INVALID_CELL_ITEM)
				_on_block_destroyed.emit(cell)
			return block_type.blocks_projectiles
	return true


## same shape lookup as above but without touching the block, used by queries like line of sight
func blocks_projectiles_at_shape(body_rid: RID, body_shape_index: int) -> bool:
	var item := get_cell_item(_get_cell_from_shape(body_rid, body_shape_index))

	for block_type in block_types:
		if block_type.gridmap_item_id == item:
			return block_type.blocks_projectiles
	return true


## cell of the given shape of this grid's physics body
func _get_cell_from_shape(body_rid: RID, body_shape_index: int) -> Vector3i:
	var shape_transform := PhysicsServer3D.body_get_shape_transform(body_rid, body_shape_index)
	return local_to_map(shape_transform.origin)
