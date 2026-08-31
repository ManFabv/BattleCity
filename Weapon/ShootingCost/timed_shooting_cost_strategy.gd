extends ShootingCostStrategy
class_name TimedShootingCostStrategy

## Base Event we will need to handle the request for the timers
@export var timer_requested : BaseEvent

## how long it will wait between shots
@export_range(0.0, 10.0) var _fire_rate : float = 1.0:
	get():
		return _fire_rate
	set(new_value):
		_fire_rate = max(new_value, 0.0) 


## here we cache if we can shoot or not based on the timer
var _has_reached_timeout: bool = true
## here we cache the timer context reference so we can use it to restart the timer when we shoot
var _timer_context: TimerContext


## at the beginning we create a new timer
func _ready() -> void:
	_timer_context = TimerContext.create_manual(_fire_rate, _on_timer_timeout, tree_exited)
	timer_requested.emit(_timer_context)


## this will check for the fire rate time to tell us if it's able to shoot
func can_shot() -> bool:
	# we handle the value of the variable on the timeout callback
	if _has_reached_timeout:
		# we reset the variable
		_has_reached_timeout = false
		# we manually restart because the timer is manual, we don't want to restart it on the timeout
		# this way the timer will only restart when we actually shoot avoiding timing issues
		_timer_context.restart_requested.emit()
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
