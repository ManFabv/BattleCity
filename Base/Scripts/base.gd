class_name Base
extends Node3D

@export_group("Events")
## emitted when the base loses all its health
@export var _on_base_destroyed : BaseEvent
## emitted when the base is requested to attach a shield
@export var _on_base_shield_requested : BaseEvent
@export_group("References")
## where attachable upgrades (ex: shields) are parented, so they are placed correctly
@export var _upgrade_attach_point : UpgradeAttachPoint
@export_group("Base Configuration")
## max starting health points for this level
@export_range(1, 10) var max_health_points : int = 1:
	set(new_value):
		# below 1 the owner would be dead from the start
		max_health_points = maxi(new_value, 1)
## color applied to the base mesh at this level
@export var base_color : Color = Color(0.752941, 0.752941, 0.752941, 1)

## the base body mesh
@onready var _mesh : TintedMesh = %TintedMesh
## manages the health for the base, reusing the same component as ControllableEntity
@onready var _health : Health = %Health


## we configure the health and color of the base and we subscribe to events
func _ready() -> void:
	_mesh.apply_color(base_color)
	_health.configure(max_health_points)
	_health.subscribe_to_health_signals(_on_health_changed, _on_dead)
	_on_base_shield_requested.subscribe(_upgrade_attach_point.attach_upgrade, tree_exited)


## handles the visual destruction of the base and removes it from the tree;
func destroy_base() -> void:
	# we emit the event so the listeners know that the base is destroyed
	_on_base_destroyed.emit()
	queue_free()


## listeners are notified when the base is destroyed, and they are unsubscribed once the base is freed
func subscribe_to_base_destroyed(on_destroyed: Callable) -> void:
	_on_base_destroyed.subscribe(on_destroyed, tree_exited)


## called every time the base takes a hit
func _on_health_changed(_max_health_points: int, _current_health: int) -> void:
	# TODO: this should be connected to the UI to show base health visually
	pass


## called when the base has no health left
func _on_dead() -> void:
	# we say that the base should be destroyed
	destroy_base()
