class_name NormalProjectile
extends Projectile


## we configure the projectile
func fire(shoot_point: Marker3D) -> void:
	# we set the position to be at the muzzle
	global_position = shoot_point.global_position
	# we initialize the movement direction from the firing origin
	_continuous_movement_strategy.initialize(shoot_point)


## for now we only remove the node from the tree
## but we can spawn particles, play sound, etc
func _destroy_projectile() -> void:
	queue_free()