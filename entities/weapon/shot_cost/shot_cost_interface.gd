class_name ShotCostInterface
extends RefCounted


## true when the weapon can pay for a shot right now
func can_shoot() -> bool:
	push_error("can_shoot() should be implemented on inherited classes")
	return false


## the weapon paid for a shot, so the cost is charged (ex: the cooldown starts)
func consume() -> void:
	push_error("consume() should be implemented on inherited classes")
