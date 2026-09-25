class_name TankShieldPowerUp
extends Pickable

## shield scene attached to the tank on pickup
@export var _shield_scene : PackedScene


func _apply_pickup(picker: ControllableEntity) -> void:
	picker.attach_upgrade(_shield_scene.instantiate() as Shield)
