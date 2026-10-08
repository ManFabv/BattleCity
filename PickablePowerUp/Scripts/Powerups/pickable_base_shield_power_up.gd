class_name PickableBaseShieldPowerUp
extends PickablePowerUpInterface

@export_group("Events")
## event announcing that a base shield was picked up, so this power-up doesn't need a reference to the base
@export var _on_base_shield_picked_up : BaseEvent
@export_group("References")
## shield scene the base instantiates and attaches to itself on pickup
@export var _shield_scene : PackedScene


func _apply_pickup(_controllable_entity_picker: ControllableEntity) -> void:
	## we announce the pickup with the shield scene, a PackedScene is refcounted so it can't leak without listeners
	_on_base_shield_picked_up.emit(_shield_scene)
