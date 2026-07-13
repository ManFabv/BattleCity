class_name Health
extends Area3D

@export var _health_stats: HealthStats


func _ready() -> void:
	# we start the entity with the max health
	_health_stats.initialize()


func initialize(_on_health_changed : Callable, _on_dead : Callable) -> void:
	#we listen to health change events
	_health_stats.on_health_changed.connect(_on_health_changed)
	#we listen to entity dead event
	_health_stats.on_dead.connect(_on_dead)


## here we take damage and emit the corresponding signal if player is dead
func take_damage(damage_stats : DamageStats) -> void:
	# we update the current health substracting the damage
	_health_stats.current_health -= damage_stats.damage


## here we take heal amount
func take_heal(heal_points : int) -> void:
	# we update the current health adding the heal
	_health_stats.current_health += heal_points
