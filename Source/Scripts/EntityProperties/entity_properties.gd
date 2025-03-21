class_name EntityProperties
extends Resource

@export_group("Movement")
## how fast the body will move
@export_range(1, 10) var _move_speed : float = 7
## how fast the body start stopping movement
@export_range(1, 10) var _move_damping : float = 10
## how much will modify the player settings gravity
@export_range(1, 10) var _gravity_modifier : float = 2
@export_group("Rotation")
## how fast the body will rotate
@export_range(1, 10) var _rotation_speed : float = 15
