class_name WeaponSystem
extends Node

## called after we just shoot
signal shot_fired

## Weapons are ordered by progression level: index 0 is the base weapon.
@export var _weapons: Array[PackedScene]

## the event where we notify that a projectile should be added to the tree
@export var _on_projectile_spawned : BaseEvent


## current equipped weapon
var _current_weapon : Weapon
## current weapon level, used to index the _weapons array
var _weapon_level: int = -1:
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
func try_shot(has_shoot_pressed: bool, muzzle: Marker3D) -> void:
	if has_shoot_pressed and _current_weapon.can_shot():
		_current_weapon.try_shot(muzzle, _on_projectile_spawned)
		shot_fired.emit()


## Equip the weapon at the requested progression index.
func change_weapon(new_level: int) -> void:
	# if it's the same level, we don't need to change anything
	if new_level == _weapon_level:
		return
	# we update the current weapon level and instantiate the new weapon
	_weapon_level = new_level
	var new_weapon_scene: PackedScene = _weapons[_weapon_level]
	# destroy the previous weapon if it exists
	if _current_weapon != null:
		_current_weapon.release_weapon()
	# we instantiate the new weapon and add it to the scene tree
	_current_weapon = new_weapon_scene.instantiate() as Weapon
	add_child(_current_weapon)


## we connect the shot_fired signal to the provided callable, allowing external systems to react when a shot is fired
func connect_on_shot_fired_signal(on_weapon_system_shot_fired : Callable) -> void:
	shot_fired.connect(on_weapon_system_shot_fired)
