extends RefCounted
class_name CustomTimer

## we use this enumeration to manage the timer state
enum TimerState { NEEDS_INIT, INITED, RUNNING, PAUSED, READY_TO_CLEANUP }

## signal emitted when the timer finishes a loop/time left
signal timeout


## current time to finish the timer
var _time_left: float = 0.0:
	get():
		return _time_left
	set(new_value):
		_time_left = max(new_value, 0.0)

## timer time that we want to wait
var _time: float = 0.0:
	get():
		return _time
	set(new_value):
		_time = max(new_value, 0.0) 


## current timer state
var _state: TimerState = TimerState.NEEDS_INIT

## if the timer should loop or not
var _loop: bool


## we cache the timer values
func _init(timer_context: TimerContext) -> void:
	_time = timer_context.time
	_loop = timer_context.loop
	# we connect the timeout signal
	timeout.connect(timer_context.timeout)
	# we init the timer
	reset()

## should be called every frame
func tick(delta: float) -> void:
	## is it's not running we return earlier
	if _is_not_running():
		return
	# we decrease the timer
	_time_left -= delta
	# because we clamp the values we know that we won't go below 0.0
	if _time_left == 0.0:
		# we trigger the signal
		_trigger_timeout()
		# if it's looping we start the timer again
		# and if it's not then we free the timer
		_handle_no_time_left()


## starts the timer
func start() -> void:
	reset()
	_state = TimerState.RUNNING


## the time is not updated
func pause() -> void:
	_state = TimerState.PAUSED


## the time is not updated (same as pause)
func stop() -> void:
	_state = TimerState.PAUSED


## we cache the initial time
func reset() -> void:
	_time_left = _time
	_state = TimerState.INITED


## we say if the timer can be removed
func is_ready_for_cleanup() -> bool:
	return _state == TimerState.READY_TO_CLEANUP


## we say if the timer is running
func _is_not_running() -> bool:
	return _state != TimerState.RUNNING


## we reset the time and emit the timeout signal
func _trigger_timeout() -> void:
	_time_left = 0.0
	timeout.emit()


## if the timer has loop set, we reset the timer
func _restart_by_loop() -> void:
	reset()
	start()


## we say that the timer can be removed
func _prepare_for_cleanup() -> void:
	_state = TimerState.READY_TO_CLEANUP


# if it's looping we start the timer again and if it's not then we free the timer
func _handle_no_time_left() -> void:
	if _loop:
		_restart_by_loop()
	else:
		_prepare_for_cleanup()
