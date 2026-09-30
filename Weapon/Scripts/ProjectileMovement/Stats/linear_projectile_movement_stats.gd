class_name LinearProjectileMovementStats
extends ProjectileMovementStatsInterface


## creates the linear movement strategy that uses this config's max speed
func create_strategy() -> ProjectileMovementStrategyInterface:
	return LinearProjectileMovementStrategy.new()
