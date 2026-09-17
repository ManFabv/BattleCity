class_name EnemyTargetDispatcher
extends Node

## event we listen to in order to know when a new enemy needs its attack targets
@export var _on_enemy_spawned : BaseEvent
## event we listen to in order to get the base reference, instead of wiring it manually
@export var _on_base_spawned : BaseEvent
## the player entity, wired manually since there is no equivalent spawned event for it
@export var _player : ControllableEntity
## captured from _on_base_spawned once the base announces itself
var _base : Base


func _ready() -> void:
	_on_enemy_spawned.subscribe(_on_enemy_spawned_handler, tree_exited)
	_on_base_spawned.subscribe(_on_base_spawned_handler, tree_exited)


func _on_enemy_spawned_handler(enemy: ControllableEntity) -> void:
	var ai_controller : AIController = enemy.entity_controller() as AIController
	ai_controller.set_attack_targets(_player, _base)


func _on_base_spawned_handler(base: Base) -> void:
	_base = base
