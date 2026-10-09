class_name NodeContainer
extends Node3D

## we are going to listen this event so we can parent the nodes
## to this object avoiding to remove nodes when their owners are removed
@export_group("Events")
@export var _on_node_spawned: BaseEvent


func _ready() -> void:
	# We start listening to the event
	_on_node_spawned.subscribe(_parent_node, tree_exited)


func _parent_node(new_node: Node) -> void:
	# we add the node as child; SpawnPoint.spawn() only emits a live, just instantiated node
	add_child(new_node)
