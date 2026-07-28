class_name Projectile
extends Area3D

## Strategy responsible for moving the projectile
@onready var _continuous_movement_strategy: ContinuousMovementStrategy = %ContinuousMovementStrategy
# reference to the component
@onready var _hurt_entity: Hurt = %Hurt


func _ready() -> void:
	# we setup the hurt area
	_hurt_entity.subscribe_to_damage_signal(_destroy_projectile)


## we configure the projectile
func fire(_shoot_point: Marker3D) -> void:
	push_error("fire() should be implemented on inherited classes")


## we move the projectile on the forward direction
func _physics_process(delta: float) -> void:
	global_transform = _continuous_movement_strategy.update_continuous_movement(delta, global_transform)


## here we check if the projectile left the screen to remove it
## this is done using the VisibleOnScreenNotifier3D node
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	# we only need to remove the projectile
	queue_free()


## for now we only remove the node from the tree
## but we can spawn particles, play sound, etc
func _destroy_projectile() -> void:
	push_error("_destroy_projectile() should be implemented on inherited classes")


func _on_body_entered(_body: Node3D) -> void:
	#we destroy the projectile after it collides with anything
	_destroy_projectile()
