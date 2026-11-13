class_name ProjectileMovementInterface
extends RefCounted


## we cache the direction the projectile moves along, called once when it is fired
func aim(_move_direction: Vector3) -> void:
	push_error("aim() should be implemented on inherited classes")


## the position the projectile moves to after the given time, called on every physics tick
func move(_position: Vector3, _delta: float) -> Vector3:
	push_error("move() should be implemented on inherited classes")
	return _position
