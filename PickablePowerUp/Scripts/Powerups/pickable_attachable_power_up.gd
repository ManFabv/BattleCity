class_name PickableAttachablePowerUp
extends PickablePowerUpInterface

@export_group("Events")
## event announcing that an attachable upgrade was picked up, so this power-up doesn't 
## need a reference to who attaches it
@export var _on_upgrade_picked_up : BaseEvent

@export_group("References")
## upgrade scene the listening attach point instantiates and attaches to its owner on pickup
@export var _upgrade_scene : PackedScene


## the pickup sends the upgrade scene, the attach point attaches it
func _apply_pickup(_controllable_entity_picker: ControllableEntity) -> void:
	# we announce the pickup with the upgrade scene, a PackedScene is ref-counted so it can't leak without listeners
	_on_upgrade_picked_up.emit(_upgrade_scene)
