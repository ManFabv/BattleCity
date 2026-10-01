class_name DamageStats
extends Resource


@export_group("Config")
## damage point to make to target
@export_range(1, 100) var damage : int = 10:
	get():
		return damage
	set(new_value):
		# we prevent negative values
		damage = max(new_value, 0)
