class_name Health
extends Area3D

signal _on_health_changed(health_stats: HealthStats)
signal _on_dead

## health stats for the entity
@export var health_stats: HealthStats


func _ready() -> void:
	# we save the health because resources are shared, 
	# so we duplicate it to avoid modifying the original resource
	health_stats = health_stats.duplicate()
	# we start the entity with the max health
	health_stats.initialize_max_health()


func subscribe_to_health_signals(on_health_changed : Callable, on_dead : Callable) -> void:
	#we listen to health change events
	_on_health_changed.connect(on_health_changed)
	#we listen to entity dead event
	_on_dead.connect(on_dead)


## here we take damage and emit the corresponding signal if player is dead
func take_damage(damage_stats : DamageStats) -> void:
	# we update the current health substracting the damage
	health_stats.current_health -= damage_stats.damage
	_emit_health_changed_signal()
	# because we clamp the current health on the setter, we won´t get less than 0
	if health_stats.current_health == 0:
		_emit_dead_signal()


## here we take heal amount
func take_heal(heal_points : int) -> void:
	# we update the current health adding the heal
	health_stats.current_health += heal_points
	_emit_health_changed_signal()


func _emit_health_changed_signal() -> void:
	# we emit the signal with the current health and max health
	_on_health_changed.emit(health_stats)


func _emit_dead_signal() -> void:
	# we notify that this entity is dead
	_on_dead.emit()
