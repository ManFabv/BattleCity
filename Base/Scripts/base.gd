class_name Base
extends Node3D

## emitted when the base loses all its health
@export var _on_base_destroyed : BaseEvent

@export_group("Base")
## health stats for the base (only supports a single enemy shot)
@export var _health_stats : HealthStats

## manages the health for the base, reusing the same component as ControllableEntity
@onready var _health : Health = %Health
## where attachable upgrades (ex: shields) are parented, so they follow the base
@onready var _upgrade_attach_point : Marker3D = %UpgradeAttachPoint


func _ready() -> void:
	_health.configure(_health_stats)
	_health.subscribe_to_health_signals(_on_health_changed, _on_dead)


## public entry point so external systems (ex: pickups) can attach an upgrade to this entity;
## the upgrade manages its own lifetime and is freed together with the base
func attach_upgrade(upgrade: Node3D) -> void:
	_upgrade_attach_point.add_child(upgrade)


## called every time the base takes a hit
func _on_health_changed(_new_health_stats: HealthStats, _current_health: float) -> void:
	# TODO: this should be connected to the UI to show base health visually
	pass


## called when the base has no health left
func _on_dead() -> void:
	destroy_base()


## handles the visual destruction of the base and removes it from the tree
func destroy_base() -> void:
	# TODO: level restart / player loses a life is out of scope here,
	# wire this once that flow exists (there is no GameManager state for it yet)
	_on_base_destroyed.emit()
	queue_free()
