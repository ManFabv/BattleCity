class_name ShootingCostConfigInterface
extends Resource

@export_group("Config")
## how many seconds the weapon waits between shots
@export_range(0.1, 10.0) var fire_rate: float = 1.0


## creates a shooting cost strategy instance matching this config
func create_strategy() -> ShootingCostStrategyInterface:
	push_error("create_strategy() should be implemented on inherited classes")
	return null
