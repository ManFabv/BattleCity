class_name GridMapNavMeshDynamicBaker
extends Node

@export_group("Rebake Config")
## how many destroyed blocks accumulate before we trigger a rebake
@export_range(1, 10) var _blocks_before_rebake : int = 3
@export_group("References")
## reference to the navigation region that we want to rebake
@export var _navigation_region : NavigationRegion3D
@export_group("Signals")
## we listen this to count destroyed blocks
@export var _on_block_destroyed : BaseEvent

## blocks destroyed that the current navmesh does not reflect yet
var _pending_blocks_count : int = 0


## we subscribe to the relevant signals
func _ready() -> void:
	_on_block_destroyed.subscribe(_on_block_destroyed_triggered, tree_exited)
	_navigation_region.bake_finished.connect(_on_bake_finished)


## counts the destroyed block and asks for a rebake once the threshold is reached
func _on_block_destroyed_triggered(_cell: Variant) -> void:
	_pending_blocks_count += 1
	# deferred so the GridMap has rebuilt its blocks
	_try_rebake.call_deferred(_blocks_before_rebake)


## blocks destroyed while baking were not in that bake: rebake if any are pending
func _on_bake_finished() -> void:
	_try_rebake()


## starts a bake if enough blocks are pending and no bake is running.
## if a bake is running we do nothing: _on_bake_finished will pick up what is pending
func _try_rebake(min_pending_blocks: int = 1) -> void:
	# if we don't have enough pending blocks, we skip the rebake
	if _pending_blocks_count < min_pending_blocks:
		return
	# if it's already baking, we skip the rebake
	if _navigation_region.is_baking():
		return
	# everything pending up to now is included in this bake
	_pending_blocks_count = 0
	# we start a new rebake
	_navigation_region.bake_navigation_mesh(true)
