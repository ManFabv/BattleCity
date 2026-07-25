extends Node
class_name ShootingCostStrategy


## this will tell us if the owner has the requisites for shooting
func can_shot(_weapon_stats: WeaponStats) -> bool:
	push_error("_can_shot() should be implemented on inherited")
	return false
