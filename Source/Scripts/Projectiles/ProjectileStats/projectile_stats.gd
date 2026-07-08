class_name ProjectileStats
extends Resource

## how fast the projectile will move
@export_range(0.0, 100.0) var speed : float = 10.0:
	get():
		return speed
	set(new_value):
		speed = new_value
