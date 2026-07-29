extends Weapon
class_name NormalWeapon


## we ask the shooting cost strategy if we can shoot or not
func can_shot() -> bool:
	return _shooting_cost_strategy.can_shot()


## the weapon will handle the shot, instantiating the projectile and firing it
func try_shot(muzzle: Marker3D, node_to_attach_to: Node) -> void:
	# we instantiate the projectile
	var shot : Projectile = projectile_scene.instantiate() as Projectile
	# we make it top level to avoid any transform issues
	shot.top_level = true
	# we add the shot to the scene (after this ready function will be triggered)
	node_to_attach_to.add_child(shot)
	# we fire the shot
	shot.fire(muzzle)


func remove_weapon() -> void:
	# nothing to do here at this moment, but we keep the function for future use
	pass
