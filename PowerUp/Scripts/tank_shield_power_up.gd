class_name TankShieldPowerUp
extends Area3D

## how long the tank becomes immune to damage
@export_range(0.0, 60.0) var _shield_duration : float = 5.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: ControllableEntity) -> void:
	body.apply_shield(_shield_duration)
	queue_free()
