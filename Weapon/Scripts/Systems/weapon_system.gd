class_name WeaponSystem
extends Node3D
## extends Node3D (instead of Node) so the equipped Weapon's mesh, mounted below it,
## follows this entity's transform -- a Node3D parented under a plain Node ignores
## everything above that plain Node and renders using its local transform as if top-level.

## called after we just shoot
signal shot_fired

## Weapons are ordered by progression level: index 0 is the base weapon.
## the event where we notify that a projectile should be added to the tree
@export var _on_projectile_spawned : BaseEvent


## current equipped weapon
var _current_weapon : Weapon


func _process(delta: float) -> void:
	# we update the weapon status
	_current_weapon.process_weapon(delta)


## this will try to shoot if it has pressed the shoot button and the weapon is able to shoot
func try_shot(has_shoot_pressed: bool) -> void:
	if has_shoot_pressed and _current_weapon.can_shot():
		_current_weapon.try_shot(_on_projectile_spawned)
		shot_fired.emit()


func subscribe_to_shot_fired(on_shot_fired: Callable) -> void:
	shot_fired.connect(on_shot_fired)


func change_weapon(config: WeaponConfig) -> void:
	if _current_weapon != null:
		_current_weapon.release_weapon()
	_current_weapon = config.weapon_scene.instantiate() as Weapon
	_current_weapon.configure(config)
	add_child(_current_weapon)
