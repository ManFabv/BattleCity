class_name HealthStats
extends Resource


signal on_health_changed(current_health: int, max_health : int)
signal on_dead


## entity max starting health points
@export_range(0, 200) var max_health : int = 100:
	get():
		return max_health
	set(new_value):
		max_health = new_value


## used to keep track of hits and heals to the entity
var current_health : int:
	set(new_value):
		# we clamp the value to avoid unrealistic values
		current_health = clamp(new_value, 0, max_health)
		# everytime we modify the health, we emit the signal
		on_health_changed.emit(current_health, max_health)
		# because we clamp the current health on the setter, we won´t get less than 0
		if current_health == 0:
			# we notify that this entity is dead
			on_dead.emit()
		
		
func initialize_max_health() -> void:
	current_health = max_health
