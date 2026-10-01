class_name Base
extends Node3D

@export_group("Signals")
## emitted when the base loses all its health
@export var _on_base_destroyed : BaseEvent
## requests the base to attach a shield (emitted by the base shield power-up)
@export var _on_base_shield_requested : BaseEvent

@export_group("Base")
## health stats for the base (only supports a single enemy shot)
@export var _health_stats : HealthStats
## color used to tint the base mesh
@export var _base_color : Color = Color(0.752941, 0.752941, 0.752941, 1)

@export_group("References")
## where attachable upgrades (ex: shields) are parented, so they are placed correctly
@export var _upgrade_attach_point : UpgradeAttachPoint

## the base body mesh
@onready var _mesh : TintedMesh = %TintedMesh
## manages the health for the base, reusing the same component as ControllableEntity
@onready var _health : Health = %Health


## we configure the health of the base
func _ready() -> void:
	_mesh.apply_color(_base_color)
	_health.configure(_health_stats)
	_health.subscribe_to_health_signals(_on_health_changed, _on_dead)
	_on_base_shield_requested.subscribe(_on_base_shield_requested_handler, tree_exited)


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
