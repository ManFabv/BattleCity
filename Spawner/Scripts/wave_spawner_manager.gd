class_name WaveSpawnerManager
extends Node

## event emitted when a node is spawned
@export var _on_node_spawned: BaseEvent
## event emitted once every wave is finished and no enemies are left alive
@export var _on_victory: BaseEvent
## spawn points managed by this manager
@export var _spawn_points: Array[WaveSpawner]
## base maximum enemies allowed at the same time
@export var _base_max_enemies: int = 3
## tracks how many enemies are currently alive, independent of this manager
@export var _enemy_alive_counter: EnemyAliveCounter

## enemies that were allowed to spawn but have not spawned yet.
## needed so we don't over-notify spawn points while a countdown is running
var _reserved_spawn_count: int = 0:
	set(new_value):
		_reserved_spawn_count = max(new_value, 0)


func _ready() -> void:
	_on_node_spawned.subscribe(_on_node_spawned_handler, tree_exited)
	_enemy_alive_counter.subscribe_to_count_changed(_on_enemy_count_changed)
	_notify_spawn_points_if_room()


## handle when a node spawns: it just used the slot that was reserved for it
func _on_node_spawned_handler(_node: Node) -> void:
	_reserved_spawn_count -= 1


func _on_enemy_count_changed(_new_count: int) -> void:
	_notify_spawn_points_if_room()
	_check_victory()


## notifies only as many spawn points as there is real room for.
## each accepted notification reserves a slot, so two spawn points
## can't both fill the same last free slot
func _notify_spawn_points_if_room() -> void:
	for spawn_point: WaveSpawner in _spawn_points:
		var available_room: int = _base_max_enemies - _enemy_alive_counter.current_count() - _reserved_spawn_count
		if available_room <= 0:
			return
		if spawn_point.allow_spawn():
			_reserved_spawn_count += 1


## the game is won once every wave is done and no enemies are left alive
func _check_victory() -> void:
	if _enemy_alive_counter.current_count() > 0:
		return
	for spawn_point: WaveSpawner in _spawn_points:
		if not spawn_point.is_finished():
			return
	_on_victory.emit()
