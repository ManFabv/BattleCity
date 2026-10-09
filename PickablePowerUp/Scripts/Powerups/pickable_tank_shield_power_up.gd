class_name PickableTankShieldPowerUp
extends PickablePowerUpInterface

@export_group("References")
## shield scene attached to the tank on pickup
@export var _shield_scene : PackedScene


## the shield is attached to the tank that picked it up
func _apply_pickup(controllable_entity_picker: ControllableEntity) -> void:
	# we attach the shield to its target
	controllable_entity_picker.attach_upgrade(_shield_scene)
