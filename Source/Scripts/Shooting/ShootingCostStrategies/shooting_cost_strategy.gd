extends Resource
class_name ShootingCostStrategy


## this will tell us if the owner has the requisites for shooting
func _can_shot(_weapon_stats: WeaponStats) -> bool:
	push_error("_can_shot() should be implemented on inherited")
	return false


## here we can update the conditions
func _process_update_conditions(_delta: float) -> void:
	push_error("_process_update_conditions() should be implemented on inherited")
