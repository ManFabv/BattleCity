extends Area3D

#how fast the projectile will move
@export_range(1, 100) var speed : float = 10

#direction where the projectile is moving
var direction : Vector3 = Vector3.FORWARD


#we move the projectile on the forward direction
func _physics_process(delta: float) -> void:
	position += direction * speed * delta


#here we check if the projectile left the screen to remove it
#this is done using the VisibleOnScreenNotifier3D node
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
