class_name ShotCostConfig
extends Resource


## creates the runtime shot cost of one weapon that uses this config
func create_shot_cost(_timer_manager: TimerManagerResource, _owner_exited: Signal) -> ShotCostInterface:
	push_error("create_shot_cost() should be implemented on inherited classes")
	return null
