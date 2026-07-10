class_name WeaponSystem
extends Node

## Weapon stats like velocity and damage
@export var _weapon_stats : WeaponStats

## Weapon stats like velocity and damage
@export var _shooting_cost_strategy : ShootingCostStrategy


func _process(delta: float) -> void:
	_shooting_cost_strategy._process_update_conditions(delta)


func try_shot(has_shoot_pressed : bool, muzzle: Marker3D) -> void:
	if has_shoot_pressed and _shooting_cost_strategy._can_shot(_weapon_stats):
		# we instantiate the projectile
		var shot : Projectile = _weapon_stats.projectile_scene.instantiate() as Projectile
		# we add the shot to the scene (after this ready function will be triggered)
		add_child(shot)
		# we fire the shot
		shot.fire(muzzle)
