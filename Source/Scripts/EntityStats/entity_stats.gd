class_name EntityStats
extends Resource


@export_group("Movement")
## how fast the body will move
@export_range(1, 10) var move_speed : float = 7:
	get():
		return move_speed
	set(newValue):
		move_speed = newValue
## how fast the body start stopping movement
@export_range(1, 10) var move_damping : float = 10:
	get():
		return move_damping
	set(newValue):
		move_damping = newValue
## how much will modify the player settings gravity
@export_range(1, 10) var gravity_modifier : float = 2:
	get():
		return gravity_modifier
	set(newValue):
		gravity_modifier = newValue

@export_group("Rotation")
## how fast the body will rotate
@export_range(1, 10) var rotation_speed : float = 15:
	get():
		return rotation_speed
	set(newValue):
		rotation_speed = newValue
