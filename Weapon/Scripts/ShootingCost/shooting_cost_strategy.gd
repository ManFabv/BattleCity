extends Node
class_name ShootingCostStrategy


## this will tell us if the owner has the requisites for shooting
func can_shot() -> bool:
	push_error("_can_shot() should be implemented on inherited")
	return false


## here we update the time passed
func process_cost(_delta: float) -> void:
	push_error("process_cost() should be implemented on inherited classes")
