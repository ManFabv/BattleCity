class_name ProjectileMovementConfig
extends Resource


## creates the runtime movement of one projectile that uses this config
func create_projectile_movement() -> ProjectileMovementInterface:
	push_error("create_projectile_movement() should be implemented on inherited classes")
	return null
