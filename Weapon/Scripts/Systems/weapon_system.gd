class_name WeaponSystem
extends Node3D

## called after we just shoot
signal _shot_fired

## current equipped weapon
var _current_weapon : WeaponInterface


## this will try to shoot, the weapon decides if it is able to (cooldown)
func try_shot() -> void:
	# the weapon handles its cooldown and tells us if it actually shot
	if _current_weapon.try_shot():
		_emit_shot_fired_signal()


## equips the given weapon, replacing the previous one
func change_weapon(weapon_config: WeaponConfig) -> void:
	# we instantiate the weapon type of the config
	var new_weapon_interface : WeaponInterface = weapon_config.weapon_scene.instantiate() as WeaponInterface
	# a weapon_scene whose root isn't a WeaponInterface can't be equipped, so we keep the current weapon
	if is_instance_valid(new_weapon_interface):
		# the previous weapon goes away together with its mesh and its timer
		if is_instance_valid(_current_weapon):
			_current_weapon.queue_free()
		# we keep the new weapon as the equipped one
		_current_weapon = new_weapon_interface
		# we configure it before it enters the tree, its _ready() reads the config
		_current_weapon.configure(weapon_config)
		# we parent it here so it follows the entity
		add_child(_current_weapon)
	else:
		# we report the misconfigured weapon config
		push_error("weapon_scene of %s is not a WeaponInterface scene" % weapon_config.resource_path)


## listeners are notified every time a shot is fired
func subscribe_to_shot_fired(on_shot_fired: Callable) -> void:
	_shot_fired.connect(on_shot_fired)


## notifies the listeners that a shot was fired
func _emit_shot_fired_signal() -> void:
	_shot_fired.emit()
