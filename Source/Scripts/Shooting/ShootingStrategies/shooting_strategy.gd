extends Resource
class_name ShootingStrategy


## Projectile stats like velocity
@export var _projectile_stats: ProjectileStats:
	get():
		return _projectile_stats
	set(new_value):
		_projectile_stats = new_value

## Strategy responsible for moving the projectile
@export var _continuous_movement_strategy: ContinuousMovementStrategy:
	get():
		return _continuous_movement_strategy
	set(new_value):
		_continuous_movement_strategy = new_value

## reference to projectile object
var _projectile : Projectile:
	get():
		return _projectile
	set(new_value):
		_projectile = new_value


## here we can setup the strategy before use
func initialize(_origin_base: Node3D, _projectile_base: Projectile) -> void:
	push_error("initialize() should be implemented on inherited")


## function responsible for updating the shooting
func update_shooting_strategy(_delta: float) -> void:
	push_error("update_shooting_strategy() should be implemented on inherited")
