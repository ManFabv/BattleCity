class_name WeaponSystem
extends Node


## the initial weapon scene to instantiate
@export var _weapon_scene : PackedScene


## current equipped weapon
var _current_weapon : Weapon


## we set the initial weapon scene to instantiate
func _ready() -> void:
	change_weapon(_weapon_scene)


## this will try to shoot if it has pressed the shoot button and the weapon is able to shoot
func try_shot(has_shoot_pressed : bool, muzzle: Marker3D, controllable_entity: ControllableEntity) -> void:
	if has_shoot_pressed and _current_weapon.can_shot():
		_current_weapon.try_shot(muzzle, controllable_entity)


func change_weapon(new_weapon_scene: PackedScene) -> void:
	# if we have a weapon we remove it
	if _current_weapon != null:
		_current_weapon.remove_weapon()
	# we instantiate the new weapon
	_current_weapon = new_weapon_scene.instantiate() as Weapon
	# we add the weapon to the scene
	add_child(_current_weapon)
