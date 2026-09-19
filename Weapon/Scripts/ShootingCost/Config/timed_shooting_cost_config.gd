class_name TimedShootingCostConfig
extends ShootingCostConfig


## creates the timed shooting cost strategy that uses this config's fire rate
func create_strategy() -> ShootingCostStrategy:
	return TimedShootingCostStrategy.new()
