class_name LinearProjectileMovementStats
extends ProjectileMovementStats


## creates the linear movement strategy that uses this config's max speed
func create_strategy() -> ProjectileMovementStrategy:
	return LinearProjectileMovementStrategy.new()
