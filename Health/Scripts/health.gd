class_name Health
extends Area3D

signal _on_health_changed(health_stats: HealthStats, current_health: float)
signal _on_dead

## health stats for the entity
@export var health_stats: HealthStats
@export var _health_stats_levels: Array[HealthStats]

var _health_level: int = 0:
	get():
		return _health_level
	set(new_value):
		_health_level = clampi(new_value, 0, _health_stats_levels.size() - 1)

## used to keep track of hits and heals to the entity
var current_health : int:
	get():
		return current_health
	set(new_value):
		# we clamp the value to avoid unrealistic values
		current_health = clamp(new_value, 0, health_stats.max_health)


## use to keep track if the entity is dead or alive
var is_dead : bool = false:
	get():
		return current_health == 0


func _ready() -> void:
	set_health_level(0)


func set_health_level(new_level: int) -> void:
	_health_level = new_level
	health_stats = _health_stats_levels[_health_level]
	_initialize_max_health()


## we initialize the current health to the max health
func _initialize_max_health() -> void:
	current_health = health_stats.max_health


func subscribe_to_health_signals(on_health_changed : Callable, on_dead : Callable) -> void:
	#we listen to health change events
	_on_health_changed.connect(on_health_changed)
	#we listen to entity dead event
	_on_dead.connect(on_dead)


## here we take damage and emit the corresponding signal if player is dead
func take_damage(damage_stats : DamageStats) -> void:
	# if the entity is already dead we don´t want to take more damage nor emit the signal
	if is_dead:
		return
	# we update the current health substracting the damage
	current_health -= damage_stats.damage
	_emit_health_changed_signal()
	# because we clamp the current health on the setter, we won´t get less than 0
	if is_dead:
		_emit_dead_signal()


## here we take heal amount
func take_heal(heal_points : int) -> void:
	# if the entity is already dead we don´t want to heal nor emit the signal
	if is_dead:
		return
	# we update the current health adding the heal
	current_health += heal_points
	_emit_health_changed_signal()


func _emit_health_changed_signal() -> void:
	# we emit the signal with the current health and max health
	_on_health_changed.emit(health_stats, current_health)


func _emit_dead_signal() -> void:
	# we notify that this entity is dead
	_on_dead.emit()
