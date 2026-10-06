class_name BaseLevelConfig
extends Resource

@export_group("Config")
## max starting health points for this level
@export_range(1, 200) var max_health_points : int = 100:
	set(new_value):
		# below 1 the owner would be dead from the start
		max_health_points = maxi(new_value, 1)
## color applied to the base mesh at this level
@export var base_color : Color = Color(0.752941, 0.752941, 0.752941, 1)
