class_name Health
extends Area3D

## emitted every time the health changes, healing or damaging
## TODO: the HUD will subscribe to it to show the health bar
signal _health_changed(max_health_points: int, current_health: int)
## emitted when the health runs out
signal _depleted

## max health points of the owner, set by configure(); the health starts full
var _max_health_points : int = 1:
	set(new_value):
		# below 1 the owner would be dead from the start
		_max_health_points = maxi(new_value, 1)
## used to keep track of hits and heals to the entity
var _current_health : int:
	set(new_value):
		# we clamp the value to avoid unrealistic values
		_current_health = clampi(new_value, 0, _max_health_points)


## we start with full health
func _ready() -> void:
	# we set the initial max health
	_initialize_max_health()


## we replace the max health points and refill the health, called when the owner levels up
func configure(max_health_points: int) -> void:
	# we cache the max health points
	_max_health_points = max_health_points
	# we set the initial max health
	_initialize_max_health()


## here we take damage and emit the corresponding signal if the health runs out
func take_damage(damage_points: int) -> void:
	# if the health is already depleted we don't want to take more damage nor emit the signal
	if _is_depleted():
		return
	# we update the current health subtracting the damage
	_current_health -= damage_points
	# we notify the new health
	_emit_health_changed_signal()
	# because we clamp the current health on the setter, we won't get less than 0
	if _is_depleted():
		_emit_depleted_signal()


## drains all the health that is left, as if it took that much damage; it does nothing if it is already depleted
func deplete() -> void:
	# take_damage() already ignores a depleted health, so the signal can't be emitted twice
	take_damage(_current_health)


## here we take heal amount
## TODO: a healing power-up will call it
func take_heal(heal_points: int) -> void:
	# if the health is already depleted we don't want to heal nor emit the signal
	if _is_depleted():
		return
	# we update the current health adding the heal
	_current_health += heal_points
	# we notify the new health
	_emit_health_changed_signal()


## we initialize the current health to the max health
func _initialize_max_health() -> void:
	_current_health = _max_health_points


## true once the health reached zero
func _is_depleted() -> bool:
	return _current_health == 0


## listeners are notified when the health runs out
func subscribe_to_depleted(on_depleted: Callable) -> void:
	# we listen to the health depleted signal
	_depleted.connect(on_depleted)


## notifies the max and current health
func _emit_health_changed_signal() -> void:
	# we emit the signal with the current health and max health
	_health_changed.emit(_max_health_points, _current_health)


## notifies that the health ran out
func _emit_depleted_signal() -> void:
	# we notify that the health is depleted
	_depleted.emit()
