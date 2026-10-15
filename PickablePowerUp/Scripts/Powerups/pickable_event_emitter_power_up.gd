class_name PickableEventEmitterPowerUp
extends PickablePowerUpInterface

@export_group("Events")
## event announcing that this power-up was picked up; every listener decides how to react
@export var _on_power_up_picked_up : BaseEvent


## the power-up only announces the pickup, each listener owns its reaction
func _apply_pickup(_controllable_entity_picker: ControllableEntity) -> void:
	# we announce that this power-up was picked up
	_on_power_up_picked_up.emit()
