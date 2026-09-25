class_name TankShieldPowerUp
extends Pickable

## how long the tank becomes immune to damage
@export_range(0.0, 60.0) var _shield_duration : float = 5.0


func _apply_pickup(picker: ControllableEntity) -> void:
	picker.apply_shield(_shield_duration)
