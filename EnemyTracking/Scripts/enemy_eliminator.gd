class_name EnemyEliminator
extends Node

## event we listen to in order to track newly spawned enemies
@export var _on_enemy_spawned : BaseEvent
## event we listen to in order to eliminate every currently tracked enemy (used by the grenade power-up)
@export var _on_eliminate_all_enemies : BaseEvent

## enemies spawned through the event above that are still alive
var _alive_enemies : Array[ControllableEntity] = []


func _ready() -> void:
	_on_enemy_spawned.subscribe(_on_enemy_spawned_handler, tree_exited)
	_on_eliminate_all_enemies.subscribe(_on_eliminate_all_enemies_handler, tree_exited)


func _on_enemy_spawned_handler(enemy: ControllableEntity) -> void:
	_alive_enemies.append(enemy)
	enemy.subscribe_to_death(_on_enemy_died.bind(enemy))


func _on_enemy_died(enemy: ControllableEntity) -> void:
	_alive_enemies.erase(enemy)


func _on_eliminate_all_enemies_handler(_event_context: Variant = null) -> void:
	# backwards, since eliminate() below triggers _on_enemy_died, which shrinks this same array
	for i in range(_alive_enemies.size() - 1, -1, -1):
		_alive_enemies[i].eliminate()
