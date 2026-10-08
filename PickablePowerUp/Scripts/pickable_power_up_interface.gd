class_name PickablePowerUpInterface
extends Area3D


## to avoid forgetting to connect the signal, we connect it here
func _ready() -> void:
	body_entered.connect(_on_body_entered)


## whoever picks it up gets the effect applied and the pickable is consumed;
## the mask only reports live player bodies, so the parameter needs no check
func _on_body_entered(controllable_entity: ControllableEntity) -> void:
	# apply pickup effect
	_apply_pickup(controllable_entity)
	# consume the pickable power-up by removing it from the scene tree
	queue_free()


## every power-up implements its own effect here
func _apply_pickup(_controllable_entity_picker: ControllableEntity) -> void:
	push_error("_apply_pickup() should be implemented on inherited classes")
