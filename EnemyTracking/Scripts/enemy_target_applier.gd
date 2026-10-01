class_name EnemyTargetApplier
extends Node
## applies the current player and base as attack targets to every alive enemy AI controller,
## both when an enemy spawns and whenever the player or the base change

@export_group("Events")
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
## current base instance, or null once the base is destroyed
var _base_target : Base


## we listen when a base and player are spawned and cached those references so we can inject them to
## the enemies when they are spawned in the level
func _ready() -> void:
	_on_enemy_spawned.subscribe(_on_enemy_spawned_handler, tree_exited)
	_on_player_spawned.subscribe(_on_player_spawned_handler, tree_exited)
	_on_base_spawned.subscribe(_on_base_spawned_handler, tree_exited)


## when an enemy is spawned we cached them and set their base and player as targets
func _on_enemy_spawned_handler(enemy: ControllableEntity) -> void:
	if is_instance_valid(enemy):
		var ai_controller : AIController = enemy.get_entity_controller() as AIController
		if is_instance_valid(ai_controller):
			# we add the new enemy to the tracked list so we can update their targets
			_tracked_enemies.append(ai_controller)
			# we want to listen when an enemy is destroyed so we stop tracking it
			enemy.subscribe_to_death(_on_tracked_enemy_died.bind(ai_controller))
			# because it's a recently spawned enemy, we need to setup its target base and player
			_apply_attack_targets(ai_controller)


## when a player is spawned we cached it and update the enemies to the new player node target
func _on_player_spawned_handler(player: ControllableEntity) -> void:
	_player_target = player
	player.subscribe_to_death(_on_player_died_handler)
	_notify_that_targets_need_update()


## when a base is spawned we cached it and update the enemies to the new base node target
func _on_base_spawned_handler(base: Base) -> void:
	_base_target = base
	_base_target.subscribe_to_base_destroyed(_on_base_destroyed_handler)
	_notify_that_targets_need_update()


## when the player is destroyed we clear it and update the enemies, so nobody keeps a freed player as target
func _on_player_died_handler() -> void:
	_player_target = null
	_notify_that_targets_need_update()


## when the base is destroyed we clear it and update the enemies, so nobody keeps a freed base as target
func _on_base_destroyed_handler(_event_context: Variant = null) -> void:
	_base_target = null
	_notify_that_targets_need_update()


## when an enemy died, we remove it from our tracking list
func _on_tracked_enemy_died(ai_controller: AIController) -> void:
	_tracked_enemies.erase(ai_controller)


## we notify that the targets need to be updated
func _notify_that_targets_need_update() -> void:
	for ai_controller : AIController in _tracked_enemies:
		_apply_attack_targets(ai_controller)


## we set the new targets to the ai controller
func _apply_attack_targets(ai_controller: AIController) -> void:
	ai_controller.set_attack_targets(_player_target, _base_target)
