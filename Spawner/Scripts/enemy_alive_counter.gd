class_name EnemyAliveCounter
extends Node

## emitted whenever the alive count changes, so listeners can react without polling
signal count_changed(current_count: int)

## event we listen to in order to track newly spawned enemies
@export var _on_enemy_spawned : BaseEvent

## how many enemies spawned through the event above are still alive
var _current_count : int = 0:
	set(new_value):
		_current_count = max(new_value, 0)


func _ready() -> void:
	_on_enemy_spawned.subscribe(_on_enemy_spawned_handler, tree_exited)


func current_count() -> int:
	return _current_count


func subscribe_to_count_changed(on_count_changed: Callable) -> void:
	count_changed.connect(on_count_changed)


func _on_enemy_spawned_handler(enemy: ControllableEntity) -> void:
	_current_count += 1
	enemy.subscribe_to_death(_on_enemy_died)
	count_changed.emit(_current_count)


func _on_enemy_died() -> void:
	_current_count -= 1
	count_changed.emit(_current_count)
