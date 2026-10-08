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
## the base body mesh
@export var _mesh : TintedMesh
## manages the health for the base, reusing the same component as ControllableEntity
@export var _health : Health
@export_group("Base Configuration")
## max starting health points for this level
@export_range(1, 10) var max_health_points : int = 1:
	set(new_value):
		# below 1 the owner would be dead from the start
		max_health_points = maxi(new_value, 1)
## color applied to the base mesh at this level
@export var base_color : Color = Color(0.752941, 0.752941, 0.752941, 1)


## we configure the health and color of the base and we subscribe to events
func _ready() -> void:
	_mesh.apply_color(base_color)
	_health.configure(max_health_points)
	_health.subscribe_to_depleted(_on_health_depleted)
	# in order to access the upgrade attach point, we subscribe to the base shield requested event
	# so when the player collects the Base Shield powerup we can attach it to the base without
	# needing to have a reference hardcoded into the powerup itself
	_on_base_shield_requested.subscribe(_upgrade_attach_point.attach_upgrade, tree_exited)


## handles the visual destruction of the base and removes it from the tree;
func destroy_base() -> void:
	# we emit the event so the listeners know that the base is destroyed
	_on_base_destroyed.emit()
	queue_free()


## listeners are notified when the base is destroyed, and they are unsubscribed once the base is freed
func subscribe_to_base_destroyed(on_destroyed: Callable) -> void:
	_on_base_destroyed.subscribe(on_destroyed, tree_exited)


## called when the base health runs out
func _on_health_depleted() -> void:
	# we say that the base should be destroyed
	destroy_base()
