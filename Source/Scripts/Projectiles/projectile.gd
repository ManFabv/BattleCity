class_name Projectile
extends Area3D

#Projectile stats like velocity and damage
@export var projectile_stats : ProjectileStats

#direction where the projectile is moving
var direction : Vector3 = Vector3.FORWARD


#we move the projectile on the forward direction
func _physics_process(delta: float) -> void:
	position += direction * projectile_stats._speed * delta


#here we check if the projectile left the screen to remove it
#this is done using the VisibleOnScreenNotifier3D node
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	# we only need to remove the projectile
	queue_free()


# if we collided with other body
func _on_body_entered(_body: Node3D) -> void:
	# TODO: if(body is ControllableEntity):
		# TODO: var controllable_entity : ControllableEntity = body as ControllableEntity
		# TODO: here we should take damage: controllable_entity.take_damage()
	#we destroy the projectile after it collides with anything
	_destroy_projectile()	


# for now we only remove the node from the tree
# but we can spawn particles, play sound, etc
func _destroy_projectile() -> void:
	queue_free()
