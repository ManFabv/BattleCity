class_name BaseShieldPowerUp
extends Pickable

## how long the base becomes immune to damage
@export_range(0.0, 60.0) var _shield_duration : float = 5.0
## the base this power-up protects, wired manually in the level (there is only one base)
@export var _base : Base


func _apply_pickup(_picker: ControllableEntity) -> void:
	# the base may have already been destroyed while this power-up was still in the level
	if is_instance_valid(_base):
		_base.apply_shield(_shield_duration)
