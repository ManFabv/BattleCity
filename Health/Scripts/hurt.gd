class_name Hurt
extends Area3D

## it's going to be triggered when taking damage
signal _on_damage_taken

## damage points applied to the health we collide with, set on configure
var _damage_points : int = 0


## to avoid having to connect this signal on every node, we connect it here
func _ready() -> void:
	area_entered.connect(_on_area_entered)


## we cache the damage points this hurt area deals
func configure(damage_points: int) -> void:
	_damage_points = damage_points


## we subscribe to damage signal
func subscribe_to_damage_signal(on_damage_taken: Callable) -> void:
	_on_damage_taken.connect(on_damage_taken)


## if we collided with other body
func _on_area_entered(health: Health) -> void:
	# we take damage when the body has a health component
	health.take_damage(_damage_points)
	# we notify that we collide with something
	_on_damage_taken.emit()
