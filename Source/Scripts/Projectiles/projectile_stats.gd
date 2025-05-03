class_name ProjectileStats
extends Resource

## how fast the projectile will move
@export_range(1, 100) var speed : float = 10:
	get():
		return speed
	set(new_value):
		speed = new_value

## damage point to make to target
@export_range(1, 100) var damage : int = 10:
	get():
		return damage
	set(new_value):
		damage = new_value
