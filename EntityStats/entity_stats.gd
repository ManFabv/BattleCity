class_name EntityStats
extends Resource

@export_group("Movement")
## how fast the body will move
@export_range(1, 100) var move_speed : float = 7

## how fast the body start stopping movement
@export_range(1, 100) var move_damping : float = 10

## how much will modify the player settings gravity
@export_range(1, 100) var gravity_modifier : float = 2

@export_group("Rotation")
## how fast the body will rotate
@export_range(1, 100) var rotation_speed : float = 15


@export_group("Non-Numeric Attributes")
## if the entity can receive damage
@export var is_invulnerable: bool = false
## current weapon level
@export var weapon_level_boost: int = 0

#we are applying the gravity defined by the setting and the multiplier set by the inspector
var gravity : float :
	get():
		return _project_settings_gravity * gravity_modifier

## project settings gravity
var _project_settings_gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
