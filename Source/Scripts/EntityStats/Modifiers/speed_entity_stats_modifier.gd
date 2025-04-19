class_name SpeedEntityStatModifier
extends EntityStatsModifier

@export_range(1, 10) var _speed_multiplier: float = 1.5

# we receive an Entity stats and we "decorate" it with our modifier
func apply(new_stats: EntityStats) -> EntityStats:
	new_stats.move_speed *= _speed_multiplier
	return new_stats
