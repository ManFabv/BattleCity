class_name WaveSpawnerManager
extends Node

## event emitted when a node is spawned
@export var _on_node_spawned: BaseEvent
## array of node paths to spawn points managed by this manager
@export var _spawn_points: Array[NodePath]
## base maximum enemies allowed at the same time
@export var _base_max_enemies: int = 3
## additional max enemies per player level
@export var _extra_max_enemies_per_level: int = 1
## tracks how many enemies are currently alive, independent of this manager
@export var _enemy_alive_counter: EnemyAliveCounter

## enemies that were allowed to spawn but have not spawned yet.
## needed so we don't over-notify spawn points while a countdown is running
var _reserved_spawn_count: int = 0
## current player level
var _player_level: int = 0
## cached references to spawn points
var _spawn_points_cached: Array[WaveSpawner] = []


func _ready() -> void:
	# cache spawn point references from node paths
	for spawn_point_path: NodePath in _spawn_points:
		var spawn_point: WaveSpawner = get_node(spawn_point_path) as WaveSpawner
		_spawn_points_cached.append(spawn_point)
	
	_on_node_spawned.subscribe(_on_node_spawned_handler, tree_exited)
	_enemy_alive_counter.count_changed.connect(_on_enemy_count_changed)
	_notify_spawn_points_if_room()


## call this from wherever you track the player's level
func set_player_level(new_level: int) -> void:
	_player_level = new_level
	_notify_spawn_points_if_room()


## calculate the maximum enemies allowed based on player level
func _max_enemies() -> int:
	return _base_max_enemies + _extra_max_enemies_per_level * _player_level


## handle when a node spawns: it just used the slot that was reserved for it
func _on_node_spawned_handler(_node: Node) -> void:
	_reserved_spawn_count = max(_reserved_spawn_count - 1, 0)


func _on_enemy_count_changed(_new_count: int) -> void:
	_notify_spawn_points_if_room()


## notifies only as many spawn points as there is real room for.
## each accepted notification reserves a slot, so two spawn points
## can't both fill the same last free slot
func _notify_spawn_points_if_room() -> void:
	for spawn_point: WaveSpawner in _spawn_points_cached:
		var available_room: int = _max_enemies() - _enemy_alive_counter.current_count() - _reserved_spawn_count
		if available_room <= 0:
			return
		if spawn_point.allow_spawn():
			_reserved_spawn_count += 1
