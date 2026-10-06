class_name PickableBaseShieldPowerUp
extends PickablePowerUpInterface

@export_group("Events")
## event requesting the base to attach the shield, so this power-up doesn't need a reference to the base
@export var _on_base_shield_requested : BaseEvent
@export_group("References")
## shield scene the base attaches to itself on pickup
@export var _shield_scene : PackedScene


func _apply_pickup(_picker: ControllableEntity) -> void:
	## we notify that a base shield is requested
	_on_base_shield_requested.emit(_shield_scene.instantiate() as Shield)
