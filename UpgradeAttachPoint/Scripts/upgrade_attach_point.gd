class_name UpgradeAttachPoint
extends Marker3D

@export_group("Events")
## event announcing that an upgrade for this attach point was picked up
## so the pickup doesn't need a reference to the owner
@export var _on_upgrade_picked_up : BaseEvent


## we subscribe to the upgrade picked up event
func _ready() -> void:
	_on_upgrade_picked_up.subscribe(_on_upgrade_picked_up_handler, tree_exited)


## the pickup sends the upgrade scene; it's instantiated and parented here
func _on_upgrade_picked_up_handler(upgrade_scene: PackedScene) -> void:
	# we instantiate the scene untyped, so we can still free it if its root isn't a Node3D
	var instance : Node3D = upgrade_scene.instantiate() as Node3D
	# we add it to the tree
	add_child(instance)
