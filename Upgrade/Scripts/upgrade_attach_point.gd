class_name UpgradeAttachPoint
extends Marker3D


## the upgrade is parented here, so it follows the owner of this attach point
func attach_upgrade(upgrade: Node3D) -> void:
	# we only attach the upgrade if it is a valid instance
	if is_instance_valid(upgrade):
		# we add it to the tree
		add_child(upgrade)
