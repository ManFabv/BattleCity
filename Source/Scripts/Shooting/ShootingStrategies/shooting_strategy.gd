extends Resource
class_name ShootingStrategy


## Strategy responsible for moving the projectile
@export var _continuous_movement_strategy: ContinuousMovementStrategy:
	get():
		return _continuous_movement_strategy
	set(new_value):
		_continuous_movement_strategy = new_value


## here we can setup the strategy before use
func initialize(origin: Node3D) -> void:
	push_error("initialize() should be implemented on inherited")


## function responsible for updating the shooting
func update_shooting_strategy(_delta: float, _projectile: Projectile) -> void:
	push_error("update_shooting_strategy() should be implemented on inherited")
