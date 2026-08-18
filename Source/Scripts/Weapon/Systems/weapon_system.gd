class_name WeaponSystem
extends Node

## called after we just shoot
signal shot_fired

## the initial weapon scene to instantiate
@export var _initial_weapon : PackedScene

## the node where we will attach the projectile to the scene tree
@export var _on_projectile_spawned : BaseEvent


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
		_current_weapon.try_shot(muzzle, _on_projectile_spawned)
		shot_fired.emit()


func change_weapon(new_weapon: PackedScene) -> void:
	# destroy the previous weapon if it exists
	if _current_weapon != null:
		_current_weapon.release_weapon()
	# we instantiate the new weapon and add it to the scene tree
	_current_weapon = new_weapon.instantiate() as Weapon
	add_child(_current_weapon)
	_current_weapon.setup_weapon()


func connect_on_shot_fired_signal(on_weapon_system_shot_fired : Callable) -> void:
	shot_fired.connect(on_weapon_system_shot_fired)
