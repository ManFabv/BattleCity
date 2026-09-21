class_name GrenadePowerUp
extends Area3D

## event requesting every currently alive enemy to be eliminated
@export var _on_eliminate_all_enemies : BaseEvent


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: ControllableEntity) -> void:
	_on_eliminate_all_enemies.emit()
	queue_free()
