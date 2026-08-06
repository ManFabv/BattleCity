extends Resource
class_name ShootingCostStrategy


## We use a local copy because we don't want the resource to be shared 
## between different entities, we want each entity to have its own values
func _init() -> void:
	resource_local_to_scene = true



## this will tell us if the owner has the requisites for shooting
func can_shot() -> bool:
	push_error("_can_shot() should be implemented on inherited")
	return false


## here we update the time passed
func process_cost(_delta: float) -> void:
	push_error("process_cost() should be implemented on inherited classes")