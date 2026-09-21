class_name StarPowerUp
extends Area3D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


## the star upgrades the tank to its next entity level (stats, health and weapon)
func _on_body_entered(body: ControllableEntity) -> void:
	body.level_up()
	queue_free()
