class_name FireRateShotCostConfig
extends ShotCostConfig

@export_group("Config")
## seconds the weapon waits between shots
@export_range(0.1, 10.0) var fire_rate_seconds : float = 1.0:
	set(new_value):
		# we prevent negative cooldowns
		fire_rate_seconds = maxf(new_value, 0.0)


## creates the fire rate shot cost of one weapon; its timer is cleaned up when the weapon leaves the tree
func create_shot_cost(timer_manager: TimerManagerResource, owner_exited: Signal) -> ShotCostInterface:
	return FireRateShotCost.new(self, timer_manager, owner_exited)
