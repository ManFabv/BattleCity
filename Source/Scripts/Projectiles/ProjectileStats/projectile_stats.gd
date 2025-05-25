class_name ProjectileStats
extends Resource

## how fast the projectile will move
@export_range(1, 100) var speed : float = 10:
	get():
		return speed
	set(new_value):
		speed = new_value
