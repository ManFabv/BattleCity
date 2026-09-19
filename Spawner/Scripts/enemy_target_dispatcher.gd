class_name EnemyTargetDispatcher
extends Node

## event we listen to in order to know when a new enemy needs its attack targets
@export var _on_enemy_spawned : BaseEvent
## the base, wired manually since it's static in the level (same pattern as _player)
@export var _base : Base
## the player entity, wired manually since it's static in the level
@export var _player : ControllableEntity


func _ready() -> void:
	_on_enemy_spawned.subscribe(_on_enemy_spawned_handler, tree_exited)


func _on_enemy_spawned_handler(enemy: ControllableEntity) -> void:
	if not is_instance_valid(enemy):
		return
	var entity_controller : EntityController = enemy.entity_controller
	if entity_controller is AIController:
		var ai_controller : AIController = entity_controller as AIController
		ai_controller.set_attack_targets(_player, _base)
