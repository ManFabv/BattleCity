class_name UpgradeAttachPoint
extends Marker3D


## the upgrade is instantiated and parented here, so it follows the owner of this attach point
func attach_upgrade(upgrade_scene: PackedScene) -> void:
	# we instantiate the scene untyped, so we can still free it if its root isn't a Node3D
	var instance : Node = upgrade_scene.instantiate()
	# we cast it to the type this attach point can place
	var upgrade : Node3D = instance as Node3D
	# only a Node3D follows the owner of this attach point
	if is_instance_valid(upgrade):
		# we add it to the tree
		add_child(upgrade)
	else:
		# we report the misconfigured scene
		push_error("UpgradeAttachPoint.attach_upgrade(): the root of %s is not a Node3D" % upgrade_scene.resource_path)
		# a node outside the tree is not reference counted, so nobody else would free it
		instance.free()
