extends Weapon
class_name NormalWeapon


## we initialize the weapon stats and the shooting cost strategy
func _ready() -> void:
	_initialize_weapon_stats()
	_initialize_shooting_cost_strategy()


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



func _initialize_weapon_stats() -> void:
	_weapon_stats = _weapon_stats.duplicate()


func _initialize_shooting_cost_strategy() -> void:
	_shooting_cost_strategy = _shooting_cost_strategy_scene.instantiate() as ShootingCostStrategy
	add_child(_shooting_cost_strategy)


func remove_weapon() -> void:
    # we remove this node from the scene tree and free it
	queue_free()