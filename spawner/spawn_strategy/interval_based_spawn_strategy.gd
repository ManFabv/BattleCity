class_name IntervalBasedSpawnStrategy
extends SpawnStrategyInterface

## the config with the scenes, the interval and the capacity
var _interval_based_spawn_strategy_config : IntervalBasedSpawnStrategyConfig
## the spawn points of the manager, in the same order as _is_spawn_point_occupied
var _spawn_points : Array[SpawnPoint]
## true while the node spawned at the spawn point of the same index is still in the tree
var _is_spawn_point_occupied : Array[bool]
## kept so the loop timer lives as long as the strategy
var _interval_timer : CustomTimer

## spawned nodes still in the tree
var _spawned_nodes_alive_count : int = 0:
	set(new_value):
		# we prevent negative counts
		_spawned_nodes_alive_count = maxi(new_value, 0)


## we cache the config
func _init(interval_based_spawn_strategy_config: IntervalBasedSpawnStrategyConfig) -> void:
	# we cache the config so we can read the scenes, interval and capacity later
	_interval_based_spawn_strategy_config = interval_based_spawn_strategy_config


## we keep the spawn points, all free, and start the interval; the first spawn comes after one interval
func start(spawn_points: Array[SpawnPoint], owner_exited: Signal) -> void:
	for spawn_point : SpawnPoint in spawn_points:
		# both arrays grow in the same if, so their indices always match
		if is_instance_valid(spawn_point):
			_spawn_points.append(spawn_point)
			_is_spawn_point_occupied.append(false)
	# the loop restarts itself, so a spawn never has to restart it from inside the callback
	_interval_timer = _interval_based_spawn_strategy_config.create_interval_timer(_on_interval_timer_timeout, owner_exited)


## spawns a random scene at a random free spawn point, if there is room
func _try_spawn() -> void:
	# a full level skips this interval
	if _spawned_nodes_alive_count >= _interval_based_spawn_strategy_config.max_alive_count:
		return
	# the free spawn points of this interval, built once every few seconds, never per frame
	var free_indices : Array[int] = []
	for index : int in _spawn_points.size():
		if not _is_spawn_point_occupied[index]:
			free_indices.append(index)
	# with every spawn point taken this interval is skipped too
	if free_indices.is_empty():
		return
	var spawn_index : int = free_indices.pick_random()
	var spawned_node : Node3D = _spawn_points[spawn_index].spawn(_interval_based_spawn_strategy_config.pick_random_scene())
	# a scene whose root isn't a Node3D was already reported and freed by the spawn point
	if is_instance_valid(spawned_node):
		_is_spawn_point_occupied[spawn_index] = true
		_spawned_nodes_alive_count += 1
		# the spawn point is free again once the node leaves the tree (ex: a pickup consumed)
		spawned_node.tree_exited.connect(_on_spawned_node_tree_exited.bind(spawn_index), CONNECT_ONE_SHOT)


## the interval elapsed: we try a spawn
func _on_interval_timer_timeout() -> void:
	_try_spawn()


## the node spawned at that spawn point left the tree, so the spawn point is free and there is room again
func _on_spawned_node_tree_exited(spawn_index: int) -> void:
	_is_spawn_point_occupied[spawn_index] = false
	_spawned_nodes_alive_count -= 1
