class_name Hurt
extends Area3D

## it´s going to be triggered when taking damage
signal _on_damage_taken

## damage that it's going to be applied
@export var _damage_stats : DamageStats


## to avoid having to connect this signal on
## every node, we connect it here
func _ready() -> void:
	area_entered.connect(_on_area_entered)


## we cache references
func subscribe_to_damage_signal(on_damage_taken: Callable) -> void:
	_on_damage_taken.connect(on_damage_taken)


## if we collided with other body
func _on_area_entered(_body: Health) -> void:
	# if the body is not a Health component, we ignore it
	if _body != null:
		# we take damage when the body has a health component
		_body.take_damage(_damage_stats)
		# we notify that we collide with something
		_on_damage_taken.emit()
