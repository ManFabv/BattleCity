class_name HealthStats
extends Resource


## entity max starting health points
@export_range(0, 200) var max_health : int = 100:
	get():
		return max_health
	set(new_value):
		max_health = max(new_value, 0)
