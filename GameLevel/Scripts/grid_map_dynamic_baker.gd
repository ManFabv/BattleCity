class_name GridMapDynamicBaker
extends Node

## how many destroyed blocks accumulate before we trigger a rebake
@export var _blocks_before_rebake : int = 3
@export var _navigation_region : NavigationRegion3D
@export var _on_block_destroyed : BaseEvent

## blocks destroyed since the last rebake
var _destroyed_count : int = 0
## true while a bake is running on the worker thread
var _is_baking : bool = false
## true when the threshold was reached again while a bake was still running
var _is_dirty : bool = false


func _ready() -> void:
	_on_block_destroyed.subscribe(_on_block_destroyed_triggered, tree_exited)
	_navigation_region.bake_finished.connect(_on_bake_finished)


## counts destroyed blocks and only rebakes once the threshold is reached
func _on_block_destroyed_triggered(_cell: Variant) -> void:
	_destroyed_count += 1
	if _destroyed_count < _blocks_before_rebake:
		return
	_destroyed_count = 0
	_try_rebake()


func _try_rebake() -> void:
	# a bake can't start while another is running; bake_finished retries it
	if _is_baking:
		_is_dirty = true
		return
	_is_baking = true
	_navigation_region.bake_navigation_mesh(true)


func _on_bake_finished() -> void:
	_is_baking = false
	if _is_dirty:
		_is_dirty = false
		_try_rebake()
