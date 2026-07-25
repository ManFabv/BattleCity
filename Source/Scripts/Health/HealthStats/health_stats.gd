class_name HealthStats
extends Resource


## entity max starting health points
@export_range(0, 200) var max_health : int = 100:
	get():
		return max_health
	set(new_value):
		max_health = new_value


## used to keep track of hits and heals to the entity
var current_health : int:
	get():
		return current_health
	set(new_value):
		# we clamp the value to avoid unrealistic values
		current_health = clamp(new_value, 0, max_health)
		
		
## we initialize the current health to the max health
func initialize_max_health() -> void:
	current_health = max_health
