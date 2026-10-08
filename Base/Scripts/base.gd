class_name Base
extends Node3D

@export_group("Events")
## emitted when the base loses all its health
@export var _on_base_destroyed : BaseEvent
## emitted when a base shield power-up was picked up
@export var _on_base_shield_picked_up : BaseEvent
@export_group("References")
## where attachable upgrades (ex: shields) are parented, so they are placed correctly
@export var _upgrade_attach_point : UpgradeAttachPoint
## the base body mesh
@export var _mesh : TintedMesh
## manages the health for the base, reusing the same component as ControllableEntity
@export var _health : Health
@export_group("Base Configuration")
## max starting health points of the base
@export_range(1, 10) var _max_health_points : int = 1:
	set(new_value):
		# below 1 the owner would be dead from the start
		_max_health_points = maxi(new_value, 1)
## color applied to the base mesh
@export var _base_color : Color = Color(0.752941, 0.752941, 0.752941, 1)


## we configure the health and color of the base and we subscribe to events
func _ready() -> void:
	_mesh.apply_color(_base_color)
	_health.configure(_max_health_points)
	_health.subscribe_to_depleted(_on_health_depleted)
	# we subscribe to the base shield picked up event, so the powerup doesn't need a reference to the base
	_on_base_shield_picked_up.subscribe(_on_base_shield_picked_up_handler, tree_exited)


## listeners are notified when the base is destroyed, and they are unsubscribed once the base is freed
func subscribe_to_base_destroyed(on_destroyed: Callable) -> void:
	_on_base_destroyed.subscribe(on_destroyed, tree_exited)


## the power-up sends the shield scene; we instantiate it here, so it can't be left orphan if the base is already gone
func _on_base_shield_picked_up_handler(shield_scene: PackedScene) -> void:
	# we attach a new shield to the base
	_upgrade_attach_point.attach_upgrade(shield_scene.instantiate() as Shield)


## called when the base health runs out, which means the base is destroyed
func _on_health_depleted() -> void:
	# we emit the event so the listeners know that the base is destroyed
	_on_base_destroyed.emit()
	# TODO: play the destruction effect before removing the base
	queue_free()
