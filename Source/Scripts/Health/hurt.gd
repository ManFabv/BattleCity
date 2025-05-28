class_name Hurt
extends Area3D

## damage that it's going to be applied
var _damage_stats : DamageStats

## it´s going to be triggered when taking damage
signal _on_damage_taken


## we cache references
func configure(damage_stats: DamageStats, on_damage_taken: Callable) -> void:
	_damage_stats = damage_stats
	_on_damage_taken.connect(on_damage_taken)


## to avoid having to connect this signal on
## every node, we connect it here
func _ready() -> void:
	connect("area_entered", _on_area_entered)


## if we collided with other body
func _on_area_entered(_body: Health) -> void:
	# we take damage when the
	if _body != null:
		_body.take_damage(_damage_stats)
		# we notify that we collide with something
		_on_damage_taken.emit()
