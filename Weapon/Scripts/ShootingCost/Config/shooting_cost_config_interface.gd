class_name ShootingCostConfigInterface
extends Resource

## which fire rate this weapon has (in shots per second)
@export_range(0.1, 10.0) var fire_rate: float = 1.0


## creates a shooting cost strategy instance matching this config
func create_strategy() -> ShootingCostStrategyInterface:
	push_error("create_strategy() should be implemented on inherited classes")
	return null
