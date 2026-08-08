extends Resource
class_name ContinuousMovementStats

## movement max speed
@export_range(0.0, 100.0) var max_speed : float = 10.0:
	get():
		return max_speed
	set(new_value):
		max_speed = max(new_value, 0.0)
