extends Resource
class_name ShootingStrategy


## Projectile stats like velocity
@warning_ignore("unused_private_class_variable")
@export var _projectile_stats: ProjectileStats

## Strategy responsible for moving the projectile
@warning_ignore("unused_private_class_variable")
@export var _continuous_movement_strategy: ContinuousMovementStrategy

## reference to projectile object
@warning_ignore("unused_private_class_variable")
var _projectile : Projectile


## here we can setup the strategy before use
func initialize(_origin_base: Node3D, _projectile_base: Projectile) -> void:
	push_error("initialize() should be implemented on inherited")


## function responsible for updating the shooting
func update_shooting_strategy(_delta: float) -> void:
	push_error("update_shooting_strategy() should be implemented on inherited")
