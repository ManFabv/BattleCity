extends ShootingStrategy
class_name NormalShootingStrategy


## here we can setup the strategy before use
func initialize(origin: Node3D) -> void:
	# because resources are references, we grab a copy of it
	_continuous_movement_strategy = _continuous_movement_strategy.duplicate()
	# we initialize the movement strategy
	_continuous_movement_strategy.initialize(origin)


## function responsible for updating the shooting
func update_shooting_strategy(delta: float, projectile: Projectile) -> void:
	_continuous_movement_strategy.update_continuous_movement(delta, projectile)
