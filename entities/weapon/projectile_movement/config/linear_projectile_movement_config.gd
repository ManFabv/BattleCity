class_name LinearProjectileMovementConfig
extends ProjectileMovementConfig

@export_group("Config")
## units per second each projectile moves; above 42 it can skip a 0.5 brick, since the area only samples once per physics tick
@export_range(0.1, 100.0) var max_speed : float = 10.0:
	set(new_value):
		# we prevent negative speeds, which would move the projectiles backwards
		max_speed = maxf(new_value, 0.0)


## creates the linear movement of one projectile that uses this config's speed
func create_projectile_movement() -> ProjectileMovementInterface:
	return LinearProjectileMovement.new(self)
