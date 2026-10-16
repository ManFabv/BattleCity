class_name EntityLevelManager
extends Node

@export_group("Events")
## event announcing that a star was picked up, the entity levels up; empty for the entities that never level up
@export var _on_star_picked_up : BaseEvent

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


## we apply the starting level and we listen to the stars
## TODO: the run state will restore the saved level here
func _ready() -> void:
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


## config for the given level index, clamped to the available levels; null with an error when there are none
func _level_config_at(index: int) -> EntityLevelConfig:
	# an entity without levels can't be configured, we report which node is wrong
	if _entity_level_configs.is_empty():
		push_error("EntityLevelManager %s has no level configs" % get_path())
		return null
	# we keep the index inside the available levels
	return _entity_level_configs[clampi(index, 0, _entity_level_configs.size() - 1)]


## we check if we are at the highest level of this entity
func _is_at_max_level() -> bool:
	return _current_level >= _entity_level_configs.size()


## applies the next level, if there is one
func _apply_next_level() -> void:
	# the config at the current level is the next one; an entity without levels was reported by the lookup
	var entity_level_config : EntityLevelConfig = _level_config_at(_current_level)
	# already at the highest level: re-applying it would refill health and rebuild the weapon for nothing
	if is_instance_valid(entity_level_config) and not _is_at_max_level():
		_configure_entity_for_level(entity_level_config)
		# we count the applied level
		_current_level += 1


## advances to the next entity level, if there is one
func _on_star_picked_up_handler(_event_context: Variant = null) -> void:
	# a picked star is a level up
	_apply_next_level()
