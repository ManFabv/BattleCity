class_name WeaponStats
extends Resource

## damage that it's going to be applied
@export var damage_stats : DamageStats:
	get():
		return damage_stats
	set(new_value):
		damage_stats = new_value


## Weapon stats like velocity and damage
@export var shooting_cost_strategy : ShootingCostStrategy:
	get():
		return shooting_cost_strategy
	set(new_value):
		shooting_cost_strategy = new_value


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


func initialize() -> void:
	shooting_cost_strategy = shooting_cost_strategy.duplicate()


## we update the cost strategy to see if we can shoot
func process_weapon(delta: float) -> void:
	shooting_cost_strategy.process_update_conditions(delta)


## we ask the shooting strategy to see if we can shoot
func can_shot() -> bool:
	return shooting_cost_strategy.can_shot(self)


func try_shot(muzzle: Marker3D, controllable_entity: ControllableEntity) -> void:
	# we instantiate the projectile
	var shot : Projectile = projectile_scene.instantiate() as Projectile
	# we add the shot to the scene (after this ready function will be triggered)
	controllable_entity.add_child(shot)
	# we fire the shot
	shot.fire(muzzle, damage_stats)
