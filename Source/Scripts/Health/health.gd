class_name Health
extends Area3D

signal on_health_changed(current_health: int, max_health : int)
signal on_dead

## entity max starting health points
@export_range(0, 200) var _max_health : int = 100

## used to keep track of hits and heals to the entity
var _current_health : int:
	set(new_value):
		# we clamp the value to avoid unrealistic values
		_current_health = clamp(new_value, 0, _max_health)
		# everytime we modify the health, we emit the signal
		on_health_changed.emit(_current_health, _max_health)


func _ready() -> void:
	# we start the entity with the max health
	_current_health = _max_health


## here we take damage and emit the corresponding signal if player is dead
func take_damage(damage : int) -> void:
	# we update the current health substracting the damage
	_current_health -= damage
	# because we clamp the current health on the setter, we won´t get less than 0
	if _current_health == 0:
		# we notify that this entity is dead
		on_dead.emit()


## here we take heal amount
func take_heal(heal_points : int) -> void:
	# we update the current health adding the heal
	_current_health += heal_points
