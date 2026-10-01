class_name WaveSpawnerManager
extends Node

## event emitted when a node is spawned
@export var _on_node_spawned: BaseEvent
## event emitted once, when every spawn point has spawned all its enemies
@export var _on_all_waves_finished: BaseEvent
## event we listen to in order to know when the alive enemies count changes
@export var _on_enemy_count_changed: BaseEvent
## spawn points managed by this manager
@export var _spawn_points: Array[WaveSpawner]
## base maximum enemies allowed at the same time
@export var _base_max_enemies: int = 3
## tracks how many enemies are currently alive, independent of this manager
@export var _enemy_alive_tracker: EnemyAliveTracker
## navigation region handed off to every spawned AIController, instead of
## each one resolving its own region rid from the navigation map
@export var _navigation_region: NavigationRegion3D

## enemies that were allowed to spawn but have not spawned yet.
## needed so we don't over-notify spawn points while a countdown is running
var _reserved_spawn_count: int = 0:
	set(new_value):
		_reserved_spawn_count = max(new_value, 0)
## true once the all waves finished event was emitted, so it's only emitted once
var _has_finished_all_waves: bool = false
## rid of the shared navigation region, cached once
var _navigation_region_rid: RID


func _ready() -> void:
	_navigation_region_rid = _navigation_region.get_rid()
	_on_node_spawned.subscribe(_on_node_spawned_handler, tree_exited)
	_on_enemy_count_changed.subscribe(_on_enemy_count_changed_handler, tree_exited)
	_notify_spawn_points_if_room()


## handle when a node spawns: it just used the slot that was reserved for it
func _on_node_spawned_handler(node: ControllableEntity) -> void:
	_reserved_spawn_count -= 1
	_assign_navigation_region(node)
	_check_all_waves_finished()


## hands the shared navigation region rid to the spawned entity's AIController, if it has one
func _assign_navigation_region(node: ControllableEntity) -> void:
	var entity_controller: EntityControllerInterface = node.get_entity_controller()
	if entity_controller is AIController:
		(entity_controller as AIController).set_navigation_region_rid(_navigation_region_rid)


func _on_enemy_count_changed_handler(_new_count: int) -> void:
	# deferred because the count can change while a spawn point is still inside its spawn timer
	# callback, where its timer still reports running and it would reject the request
	_notify_spawn_points_if_room.call_deferred()


## notifies only as many spawn points as there is real room for.
## each accepted notification reserves a slot, so two spawn points
## can't both fill the same last free slot
func _notify_spawn_points_if_room() -> void:
	for spawn_point: WaveSpawner in _spawn_points:
		var available_room: int = _base_max_enemies - _enemy_alive_tracker.get_enemies_alive_count() - _reserved_spawn_count
		if available_room <= 0:
			return
		if spawn_point.allow_spawn():
			_reserved_spawn_count += 1


## notifies once that there is nothing left to spawn, whoever listens decides what that means
func _check_all_waves_finished() -> void:
	if _has_finished_all_waves:
		return
	for spawn_point: WaveSpawner in _spawn_points:
		if not spawn_point.is_finished():
			return
	_has_finished_all_waves = true
	_on_all_waves_finished.emit()
