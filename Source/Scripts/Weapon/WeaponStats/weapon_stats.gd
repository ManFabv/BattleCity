class_name WeaponStats
extends Resource


## how long it will wait between shots
@export_range(0.0, 10.0) var fire_rate : float = 1.0:
	get():
		return fire_rate
	set(new_value):
		fire_rate = new_value


## projectile scene to instantiate
@export var projectile_scene : PackedScene:
	get():
		return projectile_scene
	set(new_value):
		projectile_scene = new_value


func try_shot(muzzle: Marker3D, controllable_entity: ControllableEntity) -> void:
	# we instantiate the projectile
	var shot : Projectile = projectile_scene.instantiate() as Projectile
	# we add the shot to the scene (after this ready function will be triggered)
	controllable_entity.add_child(shot)
	# we fire the shot
	shot.fire(muzzle)
