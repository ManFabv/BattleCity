class_name EnemyTargetApplier
extends Node
## applies the current player and base as attack targets to every enemy AI controller when it spawns;
## later player respawns reach the enemies already alive through their own on_player_spawned subscription

@export_group("Events")
## event we listen to in order to know when a new enemy needs its attack targets
@export var _on_enemy_spawned : BaseEvent
## event we listen to in order to know the current player instance
@export var _on_player_spawned : BaseEvent
## event we listen to in order to know the current base instance
@export var _on_base_spawned : BaseEvent

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


## when an enemy is spawned we set the current base and player as its targets
func _on_enemy_spawned_handler(enemy: ControllableEntity) -> void:
	if is_instance_valid(enemy):
		var ai_controller : AIController = enemy.get_entity_controller() as AIController
		if is_instance_valid(ai_controller):
			# because it's a recently spawned enemy, we need to setup its target base and player
			ai_controller.set_attack_targets(_player_target, _base_target)


## when a player is spawned we cache it for the enemies spawned from now on
func _on_player_spawned_handler(player: ControllableEntity) -> void:
	_player_target = player
	player.subscribe_to_death(_on_player_died_handler)


## when a base is spawned we cache it for the enemies spawned from now on
func _on_base_spawned_handler(base: Base) -> void:
	_base_target = base
	_base_target.subscribe_to_base_destroyed(_on_base_destroyed_handler)


## when the player is destroyed we clear it, so we never hand a freed player to a new enemy
func _on_player_died_handler() -> void:
	_player_target = null


## when the base is destroyed we clear it, so we never hand a freed base to a new enemy
func _on_base_destroyed_handler(_event_context: Variant = null) -> void:
	_base_target = null
