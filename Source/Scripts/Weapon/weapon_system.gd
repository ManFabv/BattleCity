class_name WeaponSystem
extends Node

## Weapon stats like velocity and damage
@export var _weapon_stats : WeaponStats


## Shooting cost strategy to check if we can shoot
@onready var _shooting_cost_strategy : ShootingCostStrategy = %ShootingCostStrategy


func _ready() -> void:
	change_weapon(_weapon_stats)


func try_shot(has_shoot_pressed : bool, muzzle: Marker3D, controllable_entity: ControllableEntity) -> void:
	if has_shoot_pressed and _shooting_cost_strategy.can_shot(_weapon_stats):
		_weapon_stats.try_shot(muzzle, controllable_entity)


func change_weapon(new_weapon_stats: WeaponStats) -> void:
	_weapon_stats = new_weapon_stats.duplicate()
