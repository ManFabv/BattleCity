class_name PickableStarPowerUp
extends PickablePowerUpInterface

@export_group("Events")
## event announcing that a star was picked up; the player decides to level up
@export var _on_star_picked_up : BaseEvent


## the star only announces the pickup, the player levels itself up
func _apply_pickup(_controllable_entity_picker: ControllableEntity) -> void:
	# we announce that a star was picked up
	_on_star_picked_up.emit()
