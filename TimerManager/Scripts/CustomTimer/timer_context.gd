extends RefCounted
class_name TimerContext

## we will have different modes for the timer, one shot, loop and manual
enum TimerMode { ONE_SHOT, LOOP, MANUAL }


@warning_ignore_start("unused_signal")
## emitted to notify the timer to restart
signal restart_requested
@warning_ignore_restore("unused_signal")

## duration left for the timer
var duration: float = 0.0
## timeout callback
var timeout: Callable
## emitted when the node that requested the timer leaves the tree (queue_free, etc.)
var on_owner_freed: Signal
## variable holding the mode of the timer (one shot, loop or manual)
var mode: TimerMode = TimerMode.ONE_SHOT


## we save the references when we create a new timer context
func _init(new_time: float, new_mode: TimerMode, new_timeout: Callable, new_on_owner_freed: Signal) -> void:
	duration = new_time
	mode = new_mode
	timeout = new_timeout
	on_owner_freed = new_on_owner_freed


## create a one shot timer, after timeout, it's ready to cleanup
static func create_one_shot(_duration: float, _timeout: Callable, _on_owner_freed: Signal) -> TimerContext:
	return TimerContext.new(_duration, TimerMode.ONE_SHOT, _timeout, _on_owner_freed)


## create a looping timer, it will restart automatically
static func create_loop(_duration: float, _timeout: Callable, _on_owner_freed: Signal) -> TimerContext:
	return TimerContext.new(_duration, TimerMode.LOOP, _timeout, _on_owner_freed)


## create a manual timer, the user will have to start it manually
static func create_manual(_duration: float, _timeout: Callable, _on_owner_freed: Signal) -> TimerContext:
	return TimerContext.new(_duration, TimerMode.MANUAL, _timeout, _on_owner_freed)
