class_name EntityLevelManager
extends Node

## emitted after the configuration of the current level is applied (stats, health, weapon and color)
signal entity_configured_for_level

@export_group("Entity")
## per-level stats, health and weapon config
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

## index of the currently applied level, clamped to the levels that exist
var _current_level_index : int = 0:
	set(new_value):
		# we clamp the index so it always points to an existing level
		_current_level_index = clampi(new_value, 0, _entity_levels.last_index())


## sets the level this entity starts with; only stores the index
func set_initial_level(level: int) -> void:
	# we update the current level index, the setter clamps it
	_current_level_index = level


## applies the current level; the owner entity calls it once on its _ready()
func configure_entity_for_current_level() -> void:
	# we apply the current level
	_configure_entity_for_level(_current_level_index)


## advances to the next entity level, if there is one
func level_up() -> void:
	# already at the highest level: re-applying it would refill health and rebuild the weapon for nothing
	if not _is_at_max_level():
		_configure_entity_for_level(_current_level_index + 1)


## listeners are notified every time the level stats are applied
func subscribe_to_configured_for_level(on_configured_for_level: Callable) -> void:
	entity_configured_for_level.connect(on_configured_for_level)


## applies speed, health and weapon for the given level in one call
func _configure_entity_for_level(level: int) -> void:
	# we update the current level index, the setter clamps it
	_current_level_index = level
	# we cache the entity level config
	var entity_level_config: EntityLevelConfig = _entity_levels.level_at(_current_level_index)
	## we setup the stats manager
	_entity_stats_manager.configure(entity_level_config.entity_stats)
	## we setup the health
	_health.configure(entity_level_config.max_health_points)
	## we setup the weapon system
	_weapon_system.change_weapon(entity_level_config.weapon_config)
	## we setup the entity color
	_tintable_body_mesh.apply_color(entity_level_config.entity_color)
	# we notify that the correct entity configuration was made
	entity_configured_for_level.emit()


## we check if we are at the max level for this entity
func _is_at_max_level() -> bool:
	return _current_level_index >= _entity_levels.last_index()
