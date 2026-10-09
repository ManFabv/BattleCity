class_name CustomTimerManager
extends Node

@export_group("References")
## the shared timer list this node drives every frame
@export var _timer_manager : TimerManagerResource


## we tick every shared timer once per frame
func _process(delta: float) -> void:
	_timer_manager.tick(delta)
