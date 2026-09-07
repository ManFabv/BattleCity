class_name SpeedEntityStatModifier
extends TimedEntityStatsModifier

@export_range(1, 10) var _speed_multiplier: float = 1.5


# We modify the recalculated stats in place.
func apply(stats: EntityStats, _state: EntityState) -> void:
	stats.move_speed *= _speed_multiplier
