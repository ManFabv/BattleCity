class_name EnemyAliveTracker
extends Node

@export_group("Events")
## event we listen to in order to track newly spawned enemies
@export var _on_enemy_spawned : BaseEvent
## event emitted whenever the alive count changes, with the current count as context
@export var _on_enemy_count_changed : BaseEvent

## how many enemies spawned through the event above are still alive
var _enemies_alive_count : int = 0:
	set(new_value):
		# we prevent negative counts
		_enemies_alive_count = maxi(new_value, 0)


## we subscribe to the enemy spawned event so we can count when an enemy is spawned on scene
func _ready() -> void:
	_on_enemy_spawned.subscribe(_on_enemy_spawned_handler, tree_exited)


## we count the new enemy and we listen to its death so we can decrement the count
func _on_enemy_spawned_handler(enemy: ControllableEntity) -> void:
	# we count the enemy that was just spawned
	_enemies_alive_count += 1
	# we listen to its death to decrement the count
	enemy.subscribe_to_death(_on_enemy_died)
	# we notify that the count changed
	_on_enemy_count_changed.emit(_enemies_alive_count)


## we decrement the alive count and notify that the count changed
func _on_enemy_died() -> void:
	_enemies_alive_count -= 1
	_on_enemy_count_changed.emit(_enemies_alive_count)
