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
var _weapon_level: int = 0

var weapon_level: int:
	get:
		return _weapon_level


## we set the initial weapon scene to instantiate
func _ready() -> void:
	if _weapons.is_empty():
		push_error("WeaponSystem requires at least one weapon scene")
		return
	change_weapon(0)


func _process(delta: float) -> void:
	# we update the weapon status
	if _current_weapon != null:
		_current_weapon.process_weapon(delta)


## this will try to shoot if it has pressed the shoot button and the weapon is able to shoot
func try_shot(has_shoot_pressed : bool, muzzle: Marker3D) -> void:
	if _current_weapon != null and has_shoot_pressed and _current_weapon.can_shot():
		_current_weapon.try_shot(muzzle, _on_projectile_spawned)
		shot_fired.emit()


## Equip the weapon at the requested progression index.
func change_weapon(new_level: int) -> void:
	if _weapons.is_empty():
		return
	var clamped_level: int = clampi(new_level, 0, _weapons.size() - 1)
	var new_weapon: PackedScene = _weapons[clamped_level]
	if new_weapon == null:
		push_error("WeaponSystem has an empty weapon slot at level %d" % clamped_level)
		return
	# destroy the previous weapon if it exists
	if _current_weapon != null:
		_current_weapon.release_weapon()
	# we instantiate the new weapon and add it to the scene tree
	_current_weapon = new_weapon.instantiate() as Weapon
	add_child(_current_weapon)
	_weapon_level = clamped_level


## Advance one level, for example when collecting a star power-up.
func increase_weapon_level() -> void:
	change_weapon(_weapon_level + 1)


func connect_on_shot_fired_signal(on_weapon_system_shot_fired : Callable) -> void:
	shot_fired.connect(on_weapon_system_shot_fired)
