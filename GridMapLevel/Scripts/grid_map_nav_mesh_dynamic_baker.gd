class_name GridMapNavMeshDynamicBaker
extends Node

@export_group("Rebake Config")
## how many destroyed blocks accumulate before we trigger a rebake
@export_range(1, 10) var _blocks_before_rebake : int = 3:
	set(new_value):
		# below 1 a rebake would start even without destroyed blocks
		_blocks_before_rebake = maxi(new_value, 1)
@export_group("Events")
## event announcing the base, static geometry that only exists at runtime
@export var _on_base_spawned : BaseEvent
@export_group("References")
## reference to the navigation region that we want to rebake
@export var _navigation_region : NavigationRegion3D
## the level whose destroyed blocks we count
@export var _grid_map_level : GridMapLevel

## geometry changes (destroyed blocks, spawned base) that the current navmesh does not reflect yet
var _pending_changes_count : int = 0:
	set(new_value):
		# we prevent negative counts
		_pending_changes_count = maxi(new_value, 0)


## we subscribe to the relevant signals
func _ready() -> void:
	_grid_map_level.subscribe_to_block_destroyed(_on_grid_map_level_block_destroyed)
	_navigation_region.bake_finished.connect(_on_navigation_region_bake_finished)
	_on_base_spawned.subscribe(_on_base_spawned_handler, tree_exited)


## counts the destroyed block and asks for a rebake once the threshold is reached
func _on_grid_map_level_block_destroyed(_cell: Vector3i) -> void:
	_pending_changes_count += 1
	# deferred so the GridMap has rebuilt its blocks
	_try_rebake.call_deferred(_blocks_before_rebake)


## the base blocks the way from now on, so we rebake right away
func _on_base_spawned_handler(_base: Base) -> void:
	_pending_changes_count += 1
	# deferred because the spawn point places the base after emitting this event
	_try_rebake.call_deferred()


## changes made while baking were not in that bake: rebake if any are pending
func _on_navigation_region_bake_finished() -> void:
	_try_rebake()


## starts a bake if enough changes are pending; while one runs, its bake_finished picks them up
func _try_rebake(min_pending_changes: int = 1) -> void:
	# if we don't have enough pending changes, we skip the rebake
	if _pending_changes_count < min_pending_changes:
		return
	# if it's already baking, we skip the rebake
	if _navigation_region.is_baking():
		return
	# everything pending up to now is included in this bake
	_pending_changes_count = 0
	# we start a new rebake
	_navigation_region.bake_navigation_mesh(true)
