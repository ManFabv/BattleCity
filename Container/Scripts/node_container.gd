class_name NodeContainer
extends Node3D
## parents spawned nodes, so they outlive whoever spawned them

@export_group("Events")
## event carrying the spawned node, still outside the tree
@export var _on_node_spawned: BaseEvent


## we listen to the spawned event; being first in tree order makes us its first listener
func _ready() -> void:
	_on_node_spawned.subscribe(_on_node_spawned_handler, tree_exited)


## we add the node as child, which runs its _ready()
func _on_node_spawned_handler(new_node: Node) -> void:
	add_child(new_node)
