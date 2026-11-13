class_name Base
extends Node3D

@export_group("Events")
## emitted when the base loses all its health
@export var _on_base_destroyed : BaseEvent

@export_group("References")
## manages the health for the base, reusing the same component as ControllableEntity
@export var _health : Health


## we subscribe to events
func _ready() -> void:
	# the base is destroyed when its health runs out
	_health.subscribe_to_depleted(_on_health_depleted)


## listeners are notified when the base is destroyed, and they are unsubscribed once the base is removed from tree
func subscribe_to_base_destroyed(on_destroyed: Callable) -> void:
	_on_base_destroyed.subscribe(on_destroyed, tree_exited)


## called when the base health runs out, which means the base is destroyed
func _on_health_depleted() -> void:
	# we emit the event so the listeners know that the base is destroyed
	_on_base_destroyed.emit()
	# TODO: play the destruction effect before removing the base
	queue_free()
