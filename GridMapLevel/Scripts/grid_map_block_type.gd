class_name GridMapBlockType
extends Resource

## whether this block can be removed when hit
@export var is_destructible: bool = false
## whether projectiles (and enemy line of sight) stop on this block; water lets them pass over
@export var blocks_projectiles: bool = true
## the MeshLibrary item id this block type maps to on the level GridMap
@export var gridmap_item_id: int = 0
