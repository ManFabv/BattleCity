class_name GridMapLevelBlocks
extends GridMap

@export_group("Events")
## event emitted whenever a destructible block is removed from this grid
@export var _on_block_destroyed : BaseEvent
@export_group("Config")
## block types placed on this grid, matched to MeshLibrary items by item_name
@export var _block_types_in_grid_map : Array[GridMapBlockType] = []

## Maps the MeshLibrary item id to a block type. This is a shorthand dictionary
var _block_type_by_item_id_dictionary : Dictionary[int, GridMapBlockType] = {}
## behavior of MeshLibrary items that have no block type: solid and indestructible
var _solid_fallback : GridMapBlockType = GridMapBlockType.new()


## we build the items lookup dictionary
func _ready() -> void:
	_build_lookup()


## resolves a hit on this grid's physics body by asking the physics server which
## shape was actually touched and removes the block if it's destructible
func resolve_hit_from_shape(body_rid: RID, body_shape_index: int) -> bool:
	var cell : Vector3i = _get_cell_from_shape(body_rid, body_shape_index)
	var block_type : GridMapBlockType = _get_block_type_at_cell(cell)
	# if it's an empty cell we don't take it as a hit: the physics shape is stale
	# (the block was already destroyed this frame) so the projectile keeps flying
	if block_type == null:
		return false
	# if it's a destructible cell we destroy it
	if block_type.is_destructible:
		_destroy_block(cell)
	return true


## block type of the given cell, or null if the cell is empty
func _get_block_type_at_cell(cell: Vector3i) -> GridMapBlockType:
	var item_id : int = get_cell_item(cell)
	if item_id == GridMap.INVALID_CELL_ITEM:
		return null
	# the item exists in the MeshLibrary but nobody mapped it: solid fallback
	return _block_type_by_item_id_dictionary.get(item_id, _solid_fallback)


## we mark the cell as destroyed and emit the signal to notify the listeners
func _destroy_block(cell: Vector3i) -> void:
	set_cell_item(cell, GridMap.INVALID_CELL_ITEM)
	_on_block_destroyed.emit(cell)


## cell of the given shape of this grid's physics body
func _get_cell_from_shape(body_rid: RID, body_shape_index: int) -> Vector3i:
	# the physics server gives us the transform of that shape relative to the grid body
	var shape_transform : Transform3D = PhysicsServer3D.body_get_shape_transform(body_rid, body_shape_index)
	# we convert the shape's position (local to the grid) into its grid cell coordinates
	return local_to_map(shape_transform.origin)


## resolves every block type's item_name to its MeshLibrary item id once, at startup
func _build_lookup() -> void:
	# we clear any previous data from the dictionary
	_block_type_by_item_id_dictionary.clear()
	# we check every block in the grid map
	for block_type in _block_types_in_grid_map:
		# we cache the name
		var block_type_name : String = String(block_type.item_name)
		# an empty item_name can't match any MeshLibrary item, so we report it
		if block_type_name.is_empty():
			push_error("GridMapLevelBlocks '%s': a block type has an empty item_name" % name)
			continue
		# we cache the id
		var item_id : int = mesh_library.find_item_by_name(block_type_name)
		# an item_name that isn't in the MeshLibrary would silently become a solid fallback, so we report it
		if item_id == GridMap.INVALID_CELL_ITEM:
			push_error("GridMapLevelBlocks '%s': item_name '%s' does not exist in the MeshLibrary" % [name, block_type_name])
			continue
		# we add the id -> type map to the dictionary
		_block_type_by_item_id_dictionary[item_id] = block_type
