class_name LevelGrid
extends GridMap

## block types placed on this grid, matched to cells by gridmap_item_id
@export var block_types: Array[BlockType] = []


## resolves a projectile hit at the given world position: clears the cell
## if it maps to a destructible block type
func resolve_hit(world_position: Vector3) -> void:
	var cell := local_to_map(to_local(world_position))
	var item := get_cell_item(cell)

	for block_type in block_types:
		if block_type.gridmap_item_id == item and block_type.is_destructible:
			set_cell_item(cell, GridMap.INVALID_CELL_ITEM)
