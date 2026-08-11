extends Weapon
class_name NormalWeapon


## the weapon will handle the shot, instantiating the projectile and firing it
func try_shot(muzzle: Marker3D, on_projectile_spawned: BaseEvent) -> void:
	# we instantiate the projectile
	var shot : Projectile = projectile_scene.instantiate() as Projectile
	# we make it top level to avoid any transform issues
	shot.top_level = true
	# we add the shot to the scene (after this ready function will be triggered)
	on_projectile_spawned.emit(shot)
	# we fire the shot with a movement scene
	shot.fire(muzzle, continuous_movement_scene)
