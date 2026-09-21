class_name SpeedPowerUp
extends Area3D

## the stat modifier applied to the tank on pickup
@export var _speed_modifier : EntityStatsModifier


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: ControllableEntity) -> void:
	body.apply_stat_modifier(_speed_modifier)
	queue_free()
