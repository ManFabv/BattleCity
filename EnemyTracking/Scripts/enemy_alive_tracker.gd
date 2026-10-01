class_name EnemyAliveTracker
extends Node

## emitted whenever the alive count changes, so listeners can react without polling
signal count_changed(current_count: int)

## event we listen to in order to track newly spawned enemies
@export var _on_enemy_spawned : BaseEvent

## how many enemies spawned through the event above are still alive
var _enemies_alive_count : int = 0:
	set(new_value):
		_enemies_alive_count = max(new_value, 0)


## we subscribe to the enemy spawned event so we can count when an enemy is spawned on scene
func _ready() -> void:
	_on_enemy_spawned.subscribe(_on_enemy_spawned_handler, tree_exited)


## if the instance is valid, we count it and we listen to enemy death event so we can decrement the count
func _on_enemy_spawned_handler(enemy: ControllableEntity) -> void:
	if is_instance_valid(enemy):
		_enemies_alive_count += 1
		enemy.subscribe_to_death(_on_enemy_died)
		count_changed.emit(_enemies_alive_count)


## we decrement the alive count and notify that the count changed
func _on_enemy_died() -> void:
	_enemies_alive_count -= 1
	count_changed.emit(_enemies_alive_count)


func get_enemies_alive_count() -> int:
	return _enemies_alive_count


func subscribe_to_count_changed(on_count_changed: Callable) -> void:
	count_changed.connect(on_count_changed)
