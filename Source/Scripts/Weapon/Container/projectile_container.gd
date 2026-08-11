extends Node3D
class_name ProjectileContainer

## we are going to listen this event so we can parent the projectiles
## to this object avoiding to remove projectiles when their owners are removed
@export var _on_projectile_spawned: BaseEvent


func _ready() -> void:
	# We start listening to the event
	_on_projectile_spawned.subscribe(_parent_projectile, tree_exited)


func _parent_projectile(projectile: Projectile) -> void:
	# if the parameter is a projectile
	if projectile:
		# we add the projectile as child
		add_child(projectile)
