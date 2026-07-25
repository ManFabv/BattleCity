class_name Health
extends Area3D

## health stats for the entity
@export var health_stats: HealthStats


func _ready() -> void:
	# we save the health because resources are shared, 
	# so we duplicate it to avoid modifying the original resource
	health_stats = health_stats.duplicate()
	# we start the entity with the max health
	health_stats.initialize_max_health()


func subscribe_to_health_signals(_on_health_changed : Callable, _on_dead : Callable) -> void:
	#we listen to health change events
	health_stats.on_health_changed.connect(_on_health_changed)
	#we listen to entity dead event
	health_stats.on_dead.connect(_on_dead)


## here we take damage and emit the corresponding signal if player is dead
func take_damage(damage_stats : DamageStats) -> void:
	# we update the current health substracting the damage
	health_stats.current_health -= damage_stats.damage


## here we take heal amount
func take_heal(heal_points : int) -> void:
	# we update the current health adding the heal
	health_stats.current_health += heal_points
