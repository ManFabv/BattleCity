class_name WeaponSystem
extends Node

## called after we just shoot
signal shot_fired

## the initial weapon scene to instantiate
@export var _initial_weapon : Weapon:
	get:
		return _initial_weapon
	set(new_value):
		_initial_weapon = new_value

## the node where we will attach the projectile to the scene tree
@onready var _shoot_container_node : Node = %ShootContainerNode


## current equipped weapon
var _current_weapon : Weapon


## we set the initial weapon scene to instantiate
func _ready() -> void:
	change_weapon(_initial_weapon)


func _process(delta: float) -> void:
	# we update the weapon status
	_current_weapon.process_weapon(delta)


## this will try to shoot if it has pressed the shoot button and the weapon is able to shoot
func try_shot(has_shoot_pressed : bool, muzzle: Marker3D) -> void:
	if has_shoot_pressed and _current_weapon.can_shot():
		_current_weapon.try_shot(muzzle, _shoot_container_node)
		shot_fired.emit()


func change_weapon(new_weapon: Weapon) -> void:
	# we cache the new weapon
	_current_weapon = new_weapon.duplicate()


func connect_on_shot_fired_signal(on_weapon_system_shot_fired : Callable) -> void:
	shot_fired.connect(on_weapon_system_shot_fired)
