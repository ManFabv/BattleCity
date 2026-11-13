class_name EntityLevelManager
extends Node

@export_group("Events")
## event announcing that a star was picked up, the entity levels up; empty for the entities that never level up
@export var _on_star_picked_up : BaseEvent

@export_group("Progress")
## the game progress, only the player's tank has it: it starts at the saved tank level and reports every level up
@export var _game_progress : GameProgressResource

@export_group("Entity")
## the levels the entity gets one by one; level 0 is its starting level
@export var _entity_level_configs : Array[EntityLevelConfig]

@export_group("References")
## manages the entity stats and its modifiers
@export var _entity_stats_manager : EntityStatsManager
## manages the health for the entity
@export var _health : Health
## system that will handle all the shooting logic
@export var _weapon_system : WeaponSystem
## the tank's body mesh
@export var _tintable_body_mesh : TintedMesh

## index of the next level to apply, one past the last level means the highest level
var _current_level : int = 0:
	set(new_value):
		# we clamp the level between the starting one and one past the last level
		_current_level = clampi(new_value, 0, _entity_level_configs.size())


## we apply the starting level (the saved one for the player) and we listen to the stars
func _ready() -> void:
	# an entity without levels can't be configured, we report which node is wrong
	if _entity_level_configs.is_empty():
		push_error("EntityLevelManager %s has no level configs" % get_path())
	# the player starts every life with the tank level its game level started with; the setter clamps a stale save
	if is_instance_valid(_game_progress):
		_current_level = _game_progress.get_player_entity_level()
	# the entity starts at its first level
	_apply_next_level()
	# only the entities that level up listen to the stars
	if is_instance_valid(_on_star_picked_up):
		# the picked star is a fact, this entity decides to level up
		_on_star_picked_up.subscribe(_on_star_picked_up_handler, tree_exited)


## applies stats, health, weapon and color of the given level in one call
func _configure_entity_for_level(entity_level_config: EntityLevelConfig) -> void:
	# we setup the stats manager
	_entity_stats_manager.configure(entity_level_config.entity_stats)
	# we setup the health
	_health.configure(entity_level_config.max_health_points)
	# we setup the weapon system
	_weapon_system.change_weapon(entity_level_config.weapon_config)
	# we tint the body
	_tintable_body_mesh.apply_color(entity_level_config.entity_color)
	# the weapon and its projectiles take the same color
	_weapon_system.apply_color(entity_level_config.entity_color)


## applies the next level, or refills the health when the entity is already at its highest one
func _apply_next_level() -> void:
	# one past the last level means the entity is already at its highest one
	if _current_level < _entity_level_configs.size():
		_configure_entity_for_level(_entity_level_configs[_current_level])
		# we count the applied level
		_current_level += 1
		# the progress keeps the level just applied, for the next game level if this one is won
		if is_instance_valid(_game_progress):
			_game_progress.set_current_player_entity_level(_current_level - 1)
	# at the highest level a star refills the health of that level, so a picked star always does something
	elif not _entity_level_configs.is_empty():
		_health.configure(_entity_level_configs[-1].max_health_points)


## advances to the next entity level, if there is one
func _on_star_picked_up_handler(_event_context: Variant = null) -> void:
	# a picked star is a level up
	_apply_next_level()
