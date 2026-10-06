class_name PickableStarPowerUp
extends PickablePowerUpInterface


## the star upgrades the tank to its next entity level (stats, health and weapon)
func _apply_pickup(picker: ControllableEntity) -> void:
	# we increase the tank's level
	picker.level_up()
