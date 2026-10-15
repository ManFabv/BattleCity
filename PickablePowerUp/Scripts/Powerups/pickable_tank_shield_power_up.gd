class_name PickableTankShieldPowerUp
extends PickablePowerUpInterface

@export_group("Events")
## event announcing that a tank shield was picked up, so this power-up doesn't need a reference to the tank
@export var _on_tank_shield_picked_up : BaseEvent

@export_group("References")
## shield scene the tank instantiates and attaches to itself on pickup
@export var _shield_scene : PackedScene


## the pickup sends the shield scene, the tank attaches it
func _apply_pickup(_controllable_entity_picker: ControllableEntity) -> void:
	# we announce the pickup with the shield scene, a PackedScene is ref-counted so it can't leak without listeners
	_on_tank_shield_picked_up.emit(_shield_scene)
