@tool
class_name SpawnPoint
extends Node3D

@export_group("Events")
## emitted right after instantiate(), before the new node is parented
@export var _on_spawned : BaseEvent

@export_group("References")
## shows the id above the spawn point, only visible while editing the level
@export var _id_label : Label3D

@export_group("Config")
## identifies this spawn point inside its manager, spawn entries refer to it by this id
@export_range(0, 99) var spawn_point_id : int = 0:
	set(new_value):
		# we prevent negative ids
		spawn_point_id = maxi(new_value, 0)
		# the label only exists once the node is ready
		if is_node_ready():
			# we show the new id
			_update_id_label()


## we show the id only while editing the level
func _ready() -> void:
	# the label is a level editing aid
	_id_label.visible = Engine.is_editor_hint()
	# we show the id this spawn point starts with
	_update_id_label()


## instantiates the given scene at this spawn point and returns the new node, null if its root isn't a Node3D
func spawn(scene: PackedScene) -> Node3D:
	# we instantiate the scene untyped, so we can still free it if its root isn't a Node3D
	var instance : Node = scene.instantiate()
	# we cast it to the type every listener expects
	var node : Node3D = instance as Node3D
	# only a Node3D can be placed at this spawn point
	if is_instance_valid(node):
		# the containers aren't Node3D, so this is already its global transform and its _ready() sees the final position
		node.transform = global_transform
		# the event listeners parent the node (NodeContainer.add_child)
		_emit_spawned_event(node)
	else:
		# we report the misconfigured scene
		push_error("SpawnPoint.spawn(): the root of %s is not a Node3D" % scene.resource_path)
		# a node outside the tree is not reference counted, so nobody else would free it
		instance.free()
	return node


## shows the id in the label
func _update_id_label() -> void:
	# we write the id as text
	_id_label.text = str(spawn_point_id)


## notifies the new node so the listeners can parent and track it
func _emit_spawned_event(node: Node3D) -> void:
	# we emit the spawned event with the new node as context
	_on_spawned.emit(node)
