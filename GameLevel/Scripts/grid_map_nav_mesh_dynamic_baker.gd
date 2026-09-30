class_name GridMapNavMeshDynamicBaker
extends Node

@export_group("Rebake Config")
## how many destroyed blocks accumulate before we trigger a rebake
@export_range(0, 10) var _blocks_before_rebake : int = 3
@export_group("References")
## reference to the navigation region that we want to rebake
@export var _navigation_region : NavigationRegion3D
@export_group("Signals")
## we listen this to increment the destroyed blocks count
@export var _on_block_destroyed : BaseEvent

## blocks destroyed since the last rebake
var _destroyed_blocks_count : int = 0:
	set(new_value):
		# we don't allow weird values
		_destroyed_blocks_count = clampi(new_value, 0, _blocks_before_rebake)


## we subscribe to the relevant signals
func _ready() -> void:
	_on_block_destroyed.subscribe(_on_block_destroyed_triggered, tree_exited)


## counts destroyed blocks and only rebakes once the threshold is reached
func _on_block_destroyed_triggered(_cell: Variant) -> void:
	# we increment the destroyed blocks count
	_count_new_destroyed_block()
	# if we are not above rebake threshold we exit early
	if not _are_enough_destroyed_blocks():
		return
	# if we are already baking the nav mesh we ignore this
	if _navigation_region.is_baking():
		return
	# we can safely clear the destroyed block count before baking
	_clear_destroyed_blocks_count()
	# we start a new bake
	_navigation_region.bake_navigation_mesh(true)


func _are_enough_destroyed_blocks() -> bool:
	return _destroyed_blocks_count >= _blocks_before_rebake


func _count_new_destroyed_block() -> void:
	_destroyed_blocks_count += 1


func _clear_destroyed_blocks_count() -> void:
	_destroyed_blocks_count = 0
