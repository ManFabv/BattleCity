extends Node3D
class_name NodeContainer

## we are going to listen this event so we can parent the projectiles
## to this object avoiding to remove projectiles when their owners are removed
@export var _on_node_spawned: BaseEvent


func _ready() -> void:
	# We start listening to the event
	_on_node_spawned.subscribe(_parent_node, tree_exited)


func _parent_node(new_node: Node) -> void:
	# if the parameter is valid
	if is_instance_valid(new_node):
		# we add the node as child
		add_child(new_node)
