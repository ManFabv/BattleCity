extends RefCounted
class_name TimerContext

## time left for the timer
var time: float = 0.0
## if the timer should loop
var loop: bool = false
## timeout callback
var timeout: Callable
## emitted when the node that requested the timer leaves the tree (queue_free, etc.)
var on_owner_freed: Signal


## we save the references when we create a new timer context
func _init(new_time: float, new_loop: bool, new_timeout: Callable, new_on_owner_freed: Signal) -> void:
	time = new_time
	loop = new_loop
	timeout = new_timeout
	on_owner_freed = new_on_owner_freed
