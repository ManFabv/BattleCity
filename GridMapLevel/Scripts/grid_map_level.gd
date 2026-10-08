class_name GridMapLevel
extends Node3D

@export_group("References")
## the grid whose blocks can be destroyed by projectiles
@export var _destructible_grid_map : DestructibleGridMap


## listeners are notified every time a block of this level is destroyed
func subscribe_to_block_destroyed(on_block_destroyed: Callable) -> void:
	_destructible_grid_map.subscribe_to_block_destroyed(on_block_destroyed)
