class_name DamageStats
extends Resource

## damage point to make to target
@export_range(1, 100) var damage : int = 10:
	get():
		return damage
	set(new_value):
		damage = new_value
