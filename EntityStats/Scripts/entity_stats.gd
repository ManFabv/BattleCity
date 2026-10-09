class_name EntityStats
extends Resource

@export_group("Movement")
## how fast the body will move
@export_range(1, 100) var move_speed : float = 7:
	set(new_value):
		# below 0 the body would move against its input
		move_speed = maxf(new_value, 0.0)

## seconds to go from standing still to move_speed, and from move_speed to standing still
@export_range(0.1, 5.0) var move_acceleration_time_seconds : float = 0.15:
	set(new_value):
		# ControllableEntity divides by it; below one physics tick the speed is reached instantly anyway
		move_acceleration_time_seconds = maxf(new_value, 0.01)

## multiplier of the gravity the body receives (project gravity or a gravity Area3D)
@export_range(1, 100) var gravity_modifier : float = 2:
	set(new_value):
		# below 0 the body would fall upwards
		gravity_modifier = maxf(new_value, 0.0)

@export_group("Rotation")
## how fast the body will rotate
@export_range(1, 100) var rotation_speed : float = 15:
	set(new_value):
		# below 0 rotate_toward() would turn away from the target angle
		rotation_speed = maxf(new_value, 0.0)

@export_group("Bounds")
## if the entity's vertical position drops below this value, it's eliminated (e.g. knocked off the arena)
@export_range(-100, 100) var death_vertical_position : float = -10.0
