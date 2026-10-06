class_name WeaponSystem
extends Node3D

## called after we just shoot
signal shot_fired

@export_group("Events")
## the event where we notify that a projectile should be added to the tree
@export var _on_projectile_spawned : BaseEvent

## current equipped weapon
var _current_weapon : WeaponInterface


## this will try to shoot if it has pressed the shoot button and the weapon is able to shoot
func try_shot(has_shoot_pressed: bool) -> void:
	# the weapon handles its cooldown and tells us if it actually shot
	if has_shoot_pressed and _current_weapon.try_shot(_on_projectile_spawned):
		_emit_shot_fired_signal()


## equips the given weapon, replacing the previous one
func change_weapon(weapon_config: WeaponConfig) -> void:
	# the previous weapon goes away together with its mesh and its timer
	if is_instance_valid(_current_weapon):
		_current_weapon.queue_free()
	# we instantiate the weapon type of the config
	_current_weapon = weapon_config.weapon_scene.instantiate() as WeaponInterface
	# we configure it before it enters the tree, its _ready() reads the config
	_current_weapon.configure(weapon_config)
	# we parent it here so it follows the entity
	add_child(_current_weapon)


## listeners are notified every time a shot is fired
func subscribe_to_shot_fired(on_shot_fired: Callable) -> void:
	shot_fired.connect(on_shot_fired)


## notifies the listeners that a shot was fired
func _emit_shot_fired_signal() -> void:
	shot_fired.emit()
