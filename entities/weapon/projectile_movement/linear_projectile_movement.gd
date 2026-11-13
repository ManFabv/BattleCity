class_name LinearProjectileMovement
extends ProjectileMovementInterface

## units per second the projectile moves, read once so the physics tick only reads a member
var _max_speed : float
## direction the projectile moves along
var _move_direction : Vector3 = Vector3.FORWARD


## we cache the speed of the config
func _init(linear_projectile_movement_config: LinearProjectileMovementConfig) -> void:
	# we cache the speed so the physics tick doesn't read the config
	_max_speed = linear_projectile_movement_config.max_speed


## we normalize the direction once here, so the physics tick doesn't have to
func aim(move_direction: Vector3) -> void:
	# we keep the unit direction
	_move_direction = move_direction.normalized()


## a straight line along the direction at the configured speed
func move(position: Vector3, delta: float) -> Vector3:
	return position + _move_direction * _max_speed * delta
