class_name ProjectileMovementStrategy
extends RefCounted


## here we setup the strategy before use
func configure(_stats: ProjectileMovementStats) -> void:
	push_error("configure() should be implemented on inherited")


## here we can setup the strategy before use
func initialize(_origin: Node3D) -> void:
	push_error("initialize() should be implemented on inherited")


## function responsible for calculating the movement of projectiles
func get_motion(_delta: float) -> Vector3:
	push_error("get_motion() should be implemented on inherited")
	return Vector3.ZERO
