class_name Projectile
extends CharacterBody3D


## Strategy responsible for moving the projectile
var _projectile_movement_strategy: ProjectileMovementStrategy

# reference to the component
@onready var _hurt_entity: Hurt = %Hurt


## to avoid having to connect this signal on
## every node, we connect it here
func _ready() -> void:
	_hurt_entity.subscribe_to_damage_signal(_destroy_projectile)


## we fire the projectile and fire it, setting the position and movement strategy
func fire(shoot_point: Marker3D, projectile_config: ProjectileConfig) -> void:
	# we set the position to be at the muzzle
	global_position = shoot_point.global_position
	_hurt_entity.configure(projectile_config.damage_stats)
	# initialize the projectile movement strategy
	_projectile_movement_strategy = LinearProjectileMovementStrategy.new()
	_projectile_movement_strategy.configure(projectile_config.projectile_movement_stats)
	# we initialize the movement strategy
	_projectile_movement_strategy.initialize(shoot_point)


## we move the projectile on the forward direction
func _physics_process(delta: float) -> void:
	var motion: Vector3 = _projectile_movement_strategy.get_motion(delta)
	var collision := move_and_collide(motion)
	if collision:
		_destroy_projectile()


## here we check if the projectile left the screen to remove it
## this is done using the VisibleOnScreenNotifier3D node
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	# we only need to remove the projectile
	queue_free()


## for now we only remove the node from the tree
## but we can spawn particles, play sound, etc
func _destroy_projectile() -> void:
	queue_free()
