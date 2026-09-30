class_name ShootingCostStrategyInterface
extends RefCounted


## here we initialize the strategy before use
func configure(_config: ShootingCostConfigInterface, _owner_node: Node, _timer_manager: TimerManagerResource) -> void:
	push_error("configure() should be implemented on inherited")


## this will tell us if the owner has the requisites for shooting
func can_shot() -> bool:
	push_error("can_shot() should be implemented on inherited")
	return false


## here we update the time passed
func process_cost(_delta: float) -> void:
	push_error("process_cost() should be implemented on inherited classes")
