class_name SpawnPoint
extends Node3D

@export_group("Events")
## emitted right after instantiate(), before the new node is parented
@export var _on_spawned : BaseEvent
@export_group("Config")
## identifies this spawn point inside its manager, spawn entries refer to it by this id
@export_range(0, 99) var spawn_point_id : int = 0:
	set(new_value):
		# we prevent negative ids
		spawn_point_id = maxi(new_value, 0)


## instantiate the scene_to_spawn at this spawn point and return the new node
func spawn(scene: PackedScene) -> Node3D:
	# we instantiate the node
	var node : Node3D = scene.instantiate() as Node3D
	# the event listeners parent the node (NodeContainer.add_child), global_position can only be set once it's inside the tree
	_emit_spawned_event(node)
	# we move it to this spawn point
	node.global_position = global_position
	return node


## notifies the new node so the listeners can parent and track it
func _emit_spawned_event(node: Node3D) -> void:
	# we emit the spawned event with the new node as context
	_on_spawned.emit(node)
