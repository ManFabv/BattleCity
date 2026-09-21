class_name BaseShieldPowerUp
extends Area3D

## how long the base becomes immune to damage
@export_range(0.0, 60.0) var _shield_duration : float = 5.0
## the base this power-up protects, wired manually in the level (there is only one base)
@export var _base : Base


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: ControllableEntity) -> void:
	_base.apply_shield(_shield_duration)
	queue_free()
