class_name SpawnPointInterface
extends Node3D

@export_group("Events")
## emitted right after instantiate(), before the new node is parented
@export var _on_spawned : BaseEvent


## instantiate the scene_to_spawn at this spawn point and return the new node
func spawn(scene: PackedScene) -> Node3D:
	# we instantiate the node
	var node : Node3D = scene.instantiate() as Node3D
	# the event listeners parent the node (NodeContainer.add_child), global_position can only be set once it's inside the tree
	_emit_spawned_event(node)
	# we move it to this spawn point
	node.global_position = global_position
	# we let the spawn point type react to the new node
	_on_node_spawned(node)
	return node


## notifies the new node so the listeners can parent and track it
func _emit_spawned_event(node: Node3D) -> void:
	# we emit the spawned event with the new node as context
	_on_spawned.emit(node)


## hook for each spawn point type, called once the new node is parented and positioned
func _on_node_spawned(_node: Node3D) -> void:
	push_error("_on_node_spawned() should be implemented on inherited classes")
