extends ShootingCostStrategyInterface
class_name TimedShootingCostStrategy

## how long it will wait between shots
var _fire_rate : float = 1.0


## here we cache if we can shoot or not based on the timer
var _has_reached_timeout: bool = true
## here we cache the timer reference so we can use it to restart the timer when we shoot
var _timer: CustomTimer


func configure(config: ShootingCostConfigInterface, owner_node: Node, timer_manager: TimerManagerResource) -> void:
	_fire_rate = config.fire_rate
	_timer = timer_manager.create_manual(_fire_rate, _on_timer_timeout, owner_node.tree_exited)


## this will check for the fire rate time to tell us if it's able to shoot
func can_shot() -> bool:
	# we handle the value of the variable on the timeout callback
	if _has_reached_timeout:
		# we reset the variable
		_has_reached_timeout = false
		# we manually restart because the timer is manual, we don't want to restart it on the timeout
		# this way the timer will only restart when we actually shoot avoiding timing issues
		_timer.start()
		# we say that we can shoot
		return true
	# is not ready to shoot
	return false


## here we update the time passed
func process_cost(_delta: float) -> void:
	# because now the timer for the fire rate is handled by the timer manager
	# we don't need to do nothing else here
	pass


## this method is called when the timer reaches its timeout
## so we say that we can shot
func _on_timer_timeout() -> void:
	_has_reached_timeout = true
