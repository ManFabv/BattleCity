extends ShootingCostStrategy
class_name TimedShootingCostStrategy

## how long it will wait between shots
@export_range(0.0, 10.0) var _fire_rate : float = 1.0:
	get():
		return _fire_rate
	set(new_value):
		_fire_rate = max(new_value, 0.0) 


# time accumulator
var _time_passed : float = 0.0:
	get():
		return _time_passed
	set(new_value):
		_time_passed = max(new_value, 0.0) 


## this will check for the fire rate time to tell us if it's able to shoot
func can_shot() -> bool:
	# if the time passed and is higher than the fire rate we can shoot
	if _time_passed > _fire_rate:
		# we reset the timer
		_time_passed = 0
		# we say that we can shoot
		return true
	# is not ready to shoot
	return false


## here we update the time passed
func process_cost(delta: float) -> void:
	# we increment the time passed in this frame
	_time_passed += delta
