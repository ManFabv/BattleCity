class_name EntityStats
extends Resource

@export_group("Movement")
## how fast the body will move
@export_range(1, 10) var move_speed : float = 7:
	get():
		return move_speed
	set(new_value):
		move_speed = new_value

## how fast the body start stopping movement
@export_range(1, 10) var move_damping : float = 10:
	get():
		return move_damping
	set(new_value):
		move_damping = new_value

## how much will modify the player settings gravity
@export_range(1, 10) var gravity_modifier : float = 2:
	get():
		return gravity_modifier
	set(new_value):
		gravity_modifier = new_value

@export_group("Rotation")
## how fast the body will rotate
@export_range(1, 10) var rotation_speed : float = 15:
	get():
		return rotation_speed
	set(new_value):
		rotation_speed = new_value

#we are applying the gravity defined by the setting and the multiplier set by the inspector
var gravity : float :
	get():
		return _project_settings_gravity * gravity_modifier

## project settings gravity
var _project_settings_gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
