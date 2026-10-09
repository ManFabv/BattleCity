class_name PickableGrenadePowerUp
extends PickablePowerUpInterface

@export_group("Events")
## event announcing that a grenade was picked up; every enemy decides how to react
@export var _on_grenade_picked_up : BaseEvent


## the grenade only announces the pickup, every enemy eliminates itself
func _apply_pickup(_controllable_entity_picker: ControllableEntity) -> void:
	# we announce that a grenade was picked up
	_on_grenade_picked_up.emit()
