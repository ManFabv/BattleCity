class_name TimedStatModifierNode
extends StatModifierNode


## once in the tree we request the timer that ends this modifier
## tree_exited cleans the timer if the node is freed before it finishes
func _ready() -> void:
	var timed_config : TimedEntityStatsModifier = config as TimedEntityStatsModifier
	timed_config.timer_manager.create_one_shot(timed_config.duration, _deplete, tree_exited)
