class_name HealthStats
extends Resource


@export_group("Config")
## entity max starting health points
@export_range(1, 200) var max_health : int = 100:
	get():
		return max_health
	set(new_value):
		# we prevent negative values
		max_health = max(new_value, 0)
