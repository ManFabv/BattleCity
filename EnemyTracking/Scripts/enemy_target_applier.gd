class_name EnemyTargetApplier
extends Node
## applies the current player and base as attack targets to every alive enemy AI controller,
## both when an enemy spawns and whenever the player changes

## event we listen to in order to know when a new enemy needs its attack targets
@export var _on_enemy_spawned : BaseEvent
## event we listen to in order to know the current player instance
@export var _on_player_spawned : BaseEvent
## event we listen to in order to know the current base instance
@export var _on_base_spawned : BaseEvent

## every AIController currently alive, kept up to date on player spawn/death
var _tracked_enemies : Array[AIController] = []
## current player instance, or null while there's no player alive
var _player_target : ControllableEntity
## current base instance, set when the base spawns
var _base : Base


func _ready() -> void:
	_on_enemy_spawned.subscribe(_on_enemy_spawned_handler, tree_exited)
	_on_player_spawned.subscribe(_on_player_spawned_handler, tree_exited)
	_on_base_spawned.subscribe(_on_base_spawned_handler, tree_exited)


func _on_enemy_spawned_handler(enemy: ControllableEntity) -> void:
	if not is_instance_valid(enemy):
		return
	var entity_controller : EntityControllerInterface = enemy.get_entity_controller()
	if entity_controller is AIController:
		var ai_controller : AIController = entity_controller as AIController
		_tracked_enemies.append(ai_controller)
		enemy.entity_died.connect(_on_tracked_enemy_died.bind(ai_controller), CONNECT_ONE_SHOT)
		ai_controller.set_attack_targets(_player_target, _current_base_target())


func _on_tracked_enemy_died(ai_controller: AIController) -> void:
	_tracked_enemies.erase(ai_controller)


func _on_player_spawned_handler(player: ControllableEntity) -> void:
	_player_target = player
	player.entity_died.connect(_on_player_died_handler, CONNECT_ONE_SHOT)
	_broadcast_player_target()


func _on_base_spawned_handler(base: Base) -> void:
	if is_instance_valid(base):
		_base = base


func _on_player_died_handler() -> void:
	_player_target = null
	_broadcast_player_target()


func _broadcast_player_target() -> void:
	for ai_controller : AIController in _tracked_enemies:
		ai_controller.set_attack_targets(_player_target, _current_base_target())


## once the base is destroyed (defeat), _base becomes a freed object instead of null,
## so we resolve it here before handing it out
func _current_base_target() -> Base:
	return _base if is_instance_valid(_base) else null
