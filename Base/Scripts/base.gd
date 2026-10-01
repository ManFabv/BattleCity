class_name Base
extends Node3D

@export_group("Signals")
## emitted when the base loses all its health
@export var _on_base_destroyed : BaseEvent
## requests the base to attach a shield (emitted by the base shield power-up)
@export var _on_base_shield_requested : BaseEvent

@export_group("Base")
## per-level health and color config
@export var _base_levels : BaseLevels

@export_group("References")
## where attachable upgrades (ex: shields) are parented, so they are placed correctly
@export var _upgrade_attach_point : UpgradeAttachPoint

## the base body mesh
@onready var _mesh : TintedMesh = %TintedMesh
## manages the health for the base, reusing the same component as ControllableEntity
@onready var _health : Health = %Health


## index of the currently applied level
var _current_level_index : int = 0:
	set(new_value):
		_current_level_index = clampi(new_value, 0, _base_levels.last_index())


## we configure the health and color of the base for its current level
func _ready() -> void:
	_configure_base_for_level(_current_level_index)
	_health.subscribe_to_health_signals(_on_health_changed, _on_dead)
	_on_base_shield_requested.subscribe(_on_base_shield_requested_handler, tree_exited)


## applies health and color for the given level in one call
func _configure_base_for_level(level: int) -> void:
	# we update the current level index
	_current_level_index = level
	# we cache the base level config
	var base_level_config : BaseLevelConfig = _base_levels.level_at(_current_level_index)
	# we setup the color and health
	_mesh.apply_color(base_level_config.base_color)
	_health.configure(base_level_config.health_stats)


## we check if we are at the max level for this base
func _is_at_max_level() -> bool:
	return _current_level_index >= _base_levels.last_index()


## public entry point to upgrade the base to the next level
func level_up() -> void:
	# already at the highest level: re-applying it would refill health for nothing
	if not _is_at_max_level():
		_configure_base_for_level(_current_level_index + 1)


## public entry point for pickups can attach an upgrade to the base (shield)
func attach_upgrade(upgrade: Node3D) -> void:
	# the upgrade manages its own lifetime and is freed together with the base
	_upgrade_attach_point.attach_upgrade(upgrade)


## the shield is instantiated here, so nothing is left orphaned if the base is already gone
func _on_base_shield_requested_handler(shield_scene: PackedScene) -> void:
	if is_instance_valid(shield_scene):
		var shield : Shield = shield_scene.instantiate() as Shield
		attach_upgrade(shield)


## called every time the base takes a hit
func _on_health_changed(_new_health_stats: HealthStats, _current_health: float) -> void:
	# TODO: this should be connected to the UI to show base health visually
	pass


## called when the base has no health left
func _on_dead() -> void:
	# we say that the base should be destroyed
	destroy_base()


## handles the visual destruction of the base and removes it from the tree;
func destroy_base() -> void:
	# we emit the event so the listeners know that the base is destroyed
	_on_base_destroyed.emit()
	queue_free()


## listeners are notified when the base is destroyed, and they are unsubscribed once the base is freed
func subscribe_to_base_destroyed(on_destroyed: Callable) -> void:
	_on_base_destroyed.subscribe(on_destroyed, tree_exited)
