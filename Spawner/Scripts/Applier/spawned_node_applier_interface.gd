class_name SpawnedNodeApplierInterface
extends Node

@export_group("Events")
## event we listen to in order to know when a new node needs to be applied
@export var _on_spawned : BaseEvent


## we subscribe to the signal
func _ready() -> void:
	_on_spawned.subscribe(_apply, tree_exited)


## applies this applier's dependency to the spawned node
func _apply(_entity: ControllableEntity) -> void:
	push_error("_apply() should be implemented on inherited classes")
