class_name WeaponSystem
extends Node


## the initial weapon scene to instantiate
@export var _initial_weapon : Weapon:
	get:
		return _initial_weapon
	set(new_value):
		_initial_weapon = new_value


## current equipped weapon
var _current_weapon : Weapon


## we set the initial weapon scene to instantiate
func _ready() -> void:
	change_weapon(_initial_weapon)


## this will try to shoot if it has pressed the shoot button and the weapon is able to shoot
func try_shot(has_shoot_pressed : bool, muzzle: Marker3D, controllable_entity: ControllableEntity) -> void:
	if has_shoot_pressed and _current_weapon.can_shot():
		_current_weapon.try_shot(muzzle, controllable_entity)


func change_weapon(new_weapon: Weapon) -> void:
	# if we have a weapon we remove it
	if _current_weapon != null:
		_current_weapon.remove_weapon()
	# we cache the new weapon
	_current_weapon = new_weapon.duplicate()
	# we initialize the weapon stats and the shooting cost strategy
	_current_weapon._initialize()
	# we add the weapon to the scene
	add_child(_current_weapon)
