extends Node
class_name CustomTimerManager

## the shared timer list this node drives every frame
@export var _timer_manager : TimerManagerResource


func _process(delta: float) -> void:
	_timer_manager.tick(delta)
