class_name PickablePowerUpInterface
extends Area3D


## to avoid forgetting to connect the signal, we connect it here
func _ready() -> void:
	body_entered.connect(_on_body_entered)


## whoever picks it up gets the effect applied and the pickable is consumed
func _on_body_entered(body: ControllableEntity) -> void:
	# if the instance is valid, we apply the pickup effect
	if is_instance_valid(body):
		# apply pickup effect
		_apply_pickup(body)
		# consume the pickable power-up by removing it from the scene tree
		queue_free()


## every power-up implements its own effect here
func _apply_pickup(_picker: ControllableEntity) -> void:
	push_error("_apply_pickup() should be implemented on inherited classes")
