extends Resource
class_name ProjectileMovementStats

## movement max speed
@export_range(0.0, 100.0) var max_speed : float = 10.0:
	get():
		return max_speed
	set(new_value):
		max_speed = max(new_value, 0.0)


## creates a projectile movement strategy instance matching this config
func create_strategy() -> ProjectileMovementStrategy:
	push_error("create_strategy() should be implemented on inherited classes")
	return null
