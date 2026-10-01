class_name PickableGrenadePowerUp
extends PickablePowerUpInterface

@export_group("Events")
## event requesting every currently alive enemy to be eliminated
@export var _on_eliminate_all_enemies : BaseEvent


func _apply_pickup(_picker: ControllableEntity) -> void:
	_on_eliminate_all_enemies.emit()
