class_name StarPowerUp
extends Pickable


## the star upgrades the tank to its next entity level (stats, health and weapon)
func _apply_pickup(picker: ControllableEntity) -> void:
	picker.level_up()
