class_name Health
extends Area3D

signal _on_health_changed(max_health_points: int, current_health: int)
signal _on_dead

## max health points of the entity, set on configure
var _max_health_points : int = 0:
	set(new_value):
		# we prevent negative values
		_max_health_points = maxi(new_value, 0)

## used to keep track of hits and heals to the entity
var current_health : int:
	get():
		return current_health
	set(new_value):
		# we clamp the value to avoid unrealistic values
		current_health = clampi(new_value, 0, _max_health_points)


## use to keep track if the entity is dead or alive
var is_dead : bool = false:
	get():
		return current_health == 0


## we cache the max health points and start with full health
func configure(max_health_points: int) -> void:
	# we report a max that would leave the entity dead from the start
	if max_health_points < 1:
		push_error("Health.configure() received max_health_points < 1; the entity would be dead from the start")
	# we cache the max health points
	_max_health_points = max_health_points
	# we set the initial max health
	_initialize_max_health()


## here we take damage and emit the corresponding signal if player is dead
func take_damage(damage_points: int) -> void:
	# we report a health that was never configured, because it would look dead and ignore the damage silently
	if _max_health_points < 1:
		push_error("Health.take_damage() was called before configure(); max health points is below 1")
		return
	# if the entity is already dead we don't want to take more damage nor emit the signal
	if is_dead:
		return
	# we update the current health subtracting the damage
	current_health -= damage_points
	# we notify the new health
	_emit_health_changed_signal()
	# because we clamp the current health on the setter, we won't get less than 0
	if is_dead:
		_emit_dead_signal()


## here we take heal amount
func take_heal(heal_points: int) -> void:
	# we report a health that was never configured, because it would look dead and ignore the heal silently
	if _max_health_points < 1:
		push_error("Health.take_heal() was called before configure(); max health points is below 1")
		return
	# if the entity is already dead we don't want to heal nor emit the signal
	if is_dead:
		return
	# we update the current health adding the heal
	current_health += heal_points
	# we notify the new health
	_emit_health_changed_signal()


## we initialize the current health to the max health
func _initialize_max_health() -> void:
	current_health = _max_health_points


## listeners are notified when the health changes and when the entity dies
func subscribe_to_health_signals(on_health_changed : Callable, on_dead : Callable) -> void:
	#we listen to health change events
	_on_health_changed.connect(on_health_changed)
	#we listen to entity dead event
	_on_dead.connect(on_dead)


## notifies the max and current health
func _emit_health_changed_signal() -> void:
	# we emit the signal with the current health and max health
	_on_health_changed.emit(_max_health_points, current_health)


## notifies that this entity is dead
func _emit_dead_signal() -> void:
	# we notify that this entity is dead
	_on_dead.emit()
