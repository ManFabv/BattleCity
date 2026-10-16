class_name PickablePowerUpInterface
extends Area3D


## to avoid forgetting to connect the signal, we connect it here
func _ready() -> void:
	body_entered.connect(_on_body_entered)


## the picker gets the effect and the pickable is consumed; the mask only reports player bodies
func _on_body_entered(controllable_entity: ControllableEntity) -> void:
	# apply pickup effect
	_apply_pickup(controllable_entity)
	# we consume the pickup
	_consume_pickup()


## every power-up implements its own effect here
func _apply_pickup(_controllable_entity_picker: ControllableEntity) -> void:
	push_error("_apply_pickup() should be implemented on inherited classes")


## here we can instantiate any vfx or something like that
func _consume_pickup() -> void:
	# TODO: we can apply any vfx here
	# consume the pickable power-up by removing it from the scene tree
	queue_free()