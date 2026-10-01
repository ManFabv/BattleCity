class_name PickableBaseShieldPowerUp
extends PickablePowerUpInterface

## shield scene attached to the base on pickup
@export var _shield_scene : PackedScene
## the base this power-up protects, wired manually in the level (there is only one base)
@export var _base : Base


func _apply_pickup(_picker: ControllableEntity) -> void:
	# the base may have already been destroyed while this power-up was still in the level
	if is_instance_valid(_base):
		var shield = _shield_scene.instantiate() as Shield
		_base.attach_upgrade(shield)
