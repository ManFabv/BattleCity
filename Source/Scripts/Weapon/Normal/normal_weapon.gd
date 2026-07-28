extends Weapon
class_name NormalWeapon


## we ask the shooting cost strategy if we can shoot or not
func can_shot() -> bool:
	return _shooting_cost_strategy.can_shot(_weapon_stats)


## the weapon will handle the shot, instantiating the projectile and firing it
func try_shot(muzzle: Marker3D, controllable_entity: ControllableEntity) -> void:
	# we instantiate the projectile
	var shot : Projectile = _weapon_stats.projectile_scene.instantiate() as Projectile
	# we add the shot to the scene (after this ready function will be triggered)
	controllable_entity.add_child(shot)
	# we fire the shot
	shot.fire(muzzle)


func remove_weapon() -> void:
    # we remove this node from the scene tree and free it
	queue_free()