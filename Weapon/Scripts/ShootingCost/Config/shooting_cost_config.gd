class_name ShootingCostConfig
extends Resource

## which fire rate this weapon has (in shots per second)
@export_range(0.0, 10.0) var fire_rate: float = 1.0


## creates a shooting cost strategy instance matching this config
func create_strategy() -> ShootingCostStrategy:
	push_error("create_strategy() should be implemented on inherited classes")
	return null
