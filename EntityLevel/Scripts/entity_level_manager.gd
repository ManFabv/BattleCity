class_name EntityLevelManager
extends Node

@export_group("Events")
## event announcing that a star was picked up, the entity levels up
@export var _on_star_picked_up : BaseEvent
@export_group("Entity")
## the upgrades the entity gets one by one; its starting level is the one of its scene
@export var _entity_levels : EntityLevels

@export_group("References")
## manages the entity stats and its modifiers
@export var _entity_stats_manager : EntityStatsManager
## manages the health for the entity
@export var _health : Health
## system that will handle all the shooting logic
@export var _weapon_system : WeaponSystem
## the tank's body mesh
@export var _tintable_body_mesh : TintedMesh

## upgrades applied so far, 0 is the starting level; one past the last upgrade means the highest level
var _current_level : int = 0:
	set(new_value):
		# we clamp the level between the starting one and one past the last upgrade
		_current_level = clampi(new_value, 0, _entity_levels.last_index() + 1)


## we listen to the stars
## TODO: the run state will restore the saved level here
func _ready() -> void:
	# the picked star is a fact, this entity decides to level up
	_on_star_picked_up.subscribe(_on_star_picked_up_handler, tree_exited)


## applies speed, health and weapon of the given upgrade in one call
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


## we check if we are at the highest level of this entity
func _is_at_max_level() -> bool:
	return _current_level > _entity_levels.last_index()


## advances to the next entity level, if there is one
func _on_star_picked_up_handler(_event_context: Variant = null) -> void:
	# already at the highest level: re-applying it would refill health and rebuild the weapon for nothing
	if not _is_at_max_level():
		# the upgrade at the current level is the next one
		_configure_entity_for_level(_entity_levels.level_at(_current_level))
		# we count the applied upgrade
		_current_level += 1
