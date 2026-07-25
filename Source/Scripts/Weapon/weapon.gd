extends Node3D
class_name Weapon

## the current weapons stats
@export var _weapon_stats : WeaponStats:
	get:
		return _weapon_stats
	set(new_value):
		_weapon_stats = new_value

## the current shooting cost strategy scene to instantiate
@export var _shooting_cost_strategy_scene : PackedScene:
	get:
		return _shooting_cost_strategy_scene
	set(new_value):
		_shooting_cost_strategy_scene = new_value


## the current shooting cost strategy
var _shooting_cost_strategy : ShootingCostStrategy:
	get:
		return _shooting_cost_strategy
	set(new_value):
		_shooting_cost_strategy = new_value


## we ask the shooting cost strategy if we can shoot or not
func can_shot() -> bool:
	push_error("can_shot() should be implemented on inherited classes")
	return false


## the weapon will handle the shot, instantiating the projectile and firing it
func try_shot(_muzzle: Marker3D, _controllable_entity: ControllableEntity) -> void:
	push_error("try_shot() should be implemented on inherited classes")


func remove_weapon() -> void:
	push_error("remove_weapon() should be implemented on inherited classes")