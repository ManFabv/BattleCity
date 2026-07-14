class_name WeaponSystem
extends Node

## Weapon stats like velocity and damage
@export var _weapon_stats : WeaponStats


func _ready() -> void:
	_weapon_stats = _weapon_stats.duplicate()
	_weapon_stats.initialize()


func _process(delta: float) -> void:
	_weapon_stats.process_weapon(delta)


func try_shot(has_shoot_pressed : bool, muzzle: Marker3D, controllable_entity: ControllableEntity) -> void:
	if has_shoot_pressed and _weapon_stats.can_shot():
		_weapon_stats.try_shot(muzzle, controllable_entity)
