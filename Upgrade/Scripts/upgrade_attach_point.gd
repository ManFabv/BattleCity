class_name UpgradeAttachPoint
extends Marker3D


## the upgrade (ex: shield) is parented here, so it follows the owner of this attach point
## and is freed together with it
func attach_upgrade(upgrade: Node3D) -> void:
	if is_instance_valid(upgrade):
		add_child(upgrade)
