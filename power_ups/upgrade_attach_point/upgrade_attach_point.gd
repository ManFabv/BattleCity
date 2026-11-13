class_name UpgradeAttachPoint
extends Marker3D

@export_group("Events")
## event announcing that an upgrade for this attach point was picked up
## so the pickup doesn't need a reference to the owner
@export var _on_upgrade_picked_up : BaseEvent

## the upgrade currently attached, replaced by the next pickup
var _attached_upgrade : Node3D


## we subscribe to the upgrade picked up event
func _ready() -> void:
	_on_upgrade_picked_up.subscribe(_on_upgrade_picked_up_handler, tree_exited)


## the pickup sends the upgrade scene; it's instantiated and parented here
func _on_upgrade_picked_up_handler(upgrade_scene: PackedScene) -> void:
	# a second pickup replaces the upgrade instead of stacking another one
	if is_instance_valid(_attached_upgrade):
		_attached_upgrade.queue_free()
	# the pickup assigns the scene in the editor, so its root is trusted to be a Node3D
	_attached_upgrade = upgrade_scene.instantiate() as Node3D
	# we add it to the tree
	add_child(_attached_upgrade)
