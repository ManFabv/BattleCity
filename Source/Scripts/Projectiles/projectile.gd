class_name Projectile
extends Area3D

## Projectile stats like velocity and damage
@export var _projectile_stats : ProjectileStats

## direction where the projectile is moving
var direction : Vector3 = Vector3.FORWARD


## we move the projectile on the forward direction
func _physics_process(delta: float) -> void:
	position += direction * _projectile_stats.speed * delta


## here we check if the projectile left the screen to remove it
## this is done using the VisibleOnScreenNotifier3D node
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	# we only need to remove the projectile
	queue_free()


## if we collided with other body
func _on_body_entered(_body: Node3D) -> void:
	var children = _body.get_children()
	for child in children:
		if is_instance_of(child, HealthSystem):
			var health_system : HealthSystem = child as HealthSystem
			health_system.take_damage(_projectile_stats.damage)
	#we destroy the projectile after it collides with anything
	_destroy_projectile()


# for now we only remove the node from the tree
# but we can spawn particles, play sound, etc
func _destroy_projectile() -> void:
	queue_free()
