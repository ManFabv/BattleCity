class_name SpeedEntityStatModifier
extends TimedEntityStatsModifier

## how much the speed will be multiplied by when this modifier is applied
@export_range(1, 10) var _speed_multiplier: float = 1.5


## We create a new instance of the modifier to be applied to the current stats
func create_instance() -> EntityStatsModifierInstance:
	return TimedEntityStatsModifierInstance.new(self) as EntityStatsModifierInstance


# We modify the recalculated stats in place.
func apply(stats: EntityStats) -> void:
	stats.move_speed *= _speed_multiplier
