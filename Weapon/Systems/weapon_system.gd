class_name WeaponSystem
extends Node

## called after we just shoot
signal shot_fired

## Weapons are ordered by progression level: index 0 is the base weapon.
@export var _weapons: Array[PackedScene]

## the node where we will attach the projectile to the scene tree
@export var _on_projectile_spawned : BaseEvent


## current equipped weapon
var _current_weapon : Weapon
var _weapon_level: int = 0:
	get():
		return _weapon_level
	set(new_value):
		_weapon_level = clampi(new_value, 0, _weapons.size() - 1)


## we set the initial weapon scene to instantiate
func _ready() -> void:
	change_weapon(0)


func _process(delta: float) -> void:
	# we update the weapon status
	_current_weapon.process_weapon(delta)


## this will try to shoot if it has pressed the shoot button and the weapon is able to shoot
func try_shot(has_shoot_pressed : bool, muzzle: Marker3D) -> void:
	if has_shoot_pressed and _current_weapon.can_shot():
		_current_weapon.try_shot(muzzle, _on_projectile_spawned)
		shot_fired.emit()


## Equip the weapon at the requested progression index.
func change_weapon(new_level: int) -> void:
	var new_weapon: PackedScene = _weapons[_weapon_level]
	# destroy the previous weapon if it exists
	if _current_weapon != null:
		_current_weapon.release_weapon()
	# we instantiate the new weapon and add it to the scene tree
	_current_weapon = new_weapon.instantiate() as Weapon
	add_child(_current_weapon)
	_weapon_level = new_level


func connect_on_shot_fired_signal(on_weapon_system_shot_fired : Callable) -> void:
	shot_fired.connect(on_weapon_system_shot_fired)
