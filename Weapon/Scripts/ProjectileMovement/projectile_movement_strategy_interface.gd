class_name ProjectileMovementStrategyInterface
extends RefCounted


## here we setup the strategy before use
func configure(_stats: ProjectileMovementStatsInterface, _origin: Node3D) -> void:
	push_error("configure() should be implemented on inherited")


## function responsible for calculating the movement of projectiles
func move(_transform: Transform3D, _delta: float) -> Transform3D:
	push_error("move() should be implemented on inherited")
	return _transform
