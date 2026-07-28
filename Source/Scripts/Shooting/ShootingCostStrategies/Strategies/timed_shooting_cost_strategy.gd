extends ShootingCostStrategy
class_name TimedShootingCostStrategy

# time accumulator
var _time_passed : float = 0.0:
	get():
		return _time_passed
	set(new_value):
		if new_value < 0.0:
			_time_passed = 0
		else:
			_time_passed = new_value


## this will check for the fire rate time to tell us if it's able to shoot
func can_shot(weapon: Weapon) -> bool:
	# if the time passed and is higher than the fire rate we can shoot
	if _time_passed > weapon.fire_rate:
		# we reset the timer
		_time_passed = 0
		# we say that we can shoot
		return true
	# is not ready to shoot
	return false


## here we update the time passed
func _process(delta: float) -> void:
	# we increment the time passed in this frame
	_time_passed += delta
