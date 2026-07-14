class_name Projectile
extends Area3D

## Projectile shooting strategy
@export var _shooting_strategy: ShootingStrategy

## how fast the projectile will move
@export_range(0.0, 100.0) var speed : float = 10.0:
	get():
		return speed
	set(new_value):
		speed = new_value

# reference to the component
@onready var _hurt_entity: Hurt = %Hurt


func _ready() -> void:
	# because resources are references, we grab a copy of it
	_shooting_strategy = _shooting_strategy.duplicate()
	# we setup the hurt area
	_hurt_entity.subscribe_to_damage_signal(_destroy_projectile)


## we configure the projectile
func fire(shoot_point: Marker3D, damage_stats: DamageStats) -> void:
	# we set the position to be at the muzzle
	global_position = shoot_point.global_position
	# we initialize the movement strategy
	_shooting_strategy.initialize(shoot_point)
	# we set the damage stats
	_hurt_entity.damage_stats = damage_stats.duplicate()


## we move the projectile on the forward direction
func _physics_process(delta: float) -> void:
	_shooting_strategy.update_shooting_strategy(delta, self)


## here we check if the projectile left the screen to remove it
## this is done using the VisibleOnScreenNotifier3D node
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	# we only need to remove the projectile
	queue_free()


## for now we only remove the node from the tree
## but we can spawn particles, play sound, etc
func _destroy_projectile() -> void:
	queue_free()


func _on_body_entered(_body: Node3D) -> void:
	#we destroy the projectile after it collides with anything
	_destroy_projectile()
