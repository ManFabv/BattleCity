class_name Pickable
extends Area3D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


## whoever picks it up gets the effect applied and the pickable is consumed
func _on_body_entered(body: ControllableEntity) -> void:
	_apply_pickup(body)
	queue_free()


## every power-up implements its own effect here
func _apply_pickup(_picker: ControllableEntity) -> void:
	push_error("_apply_pickup() should be implemented on inherited classes")
