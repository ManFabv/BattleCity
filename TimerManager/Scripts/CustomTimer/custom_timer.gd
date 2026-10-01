extends RefCounted
class_name CustomTimer

## we use this enumeration to manage the timer state
enum TimerState { NEEDS_INIT, INITED, RUNNING, PAUSED, READY_TO_CLEANUP }

## we will have different modes for the timer, one shot, loop and manual
enum TimerMode { ONE_SHOT, LOOP, MANUAL }

## signal emitted when the timer finishes a loop/time left
signal timeout


## current time to finish the timer
var _time_left: float = 0.0:
	get():
		return _time_left
	set(new_value):
		_time_left = max(new_value, 0.0)

## timer time that we want to wait
var _duration: float = 0.0:
	get():
		return _duration
	set(new_value):
		_duration = max(new_value, 0.0) 


## current timer state
var _state: TimerState = TimerState.NEEDS_INIT
## timer mode (will apply different strategies when we reach the timeout)
var _mode: TimerMode


## we cache the timer values
func _init(duration: float, mode: TimerMode, on_timeout: Callable) -> void:
	_duration = duration
	_mode = mode
	# we connect the timeout signal
	timeout.connect(on_timeout)
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


## starts the timer, optionally changing its duration
func start(new_duration: float = -1.0) -> void:
	if new_duration >= 0.0:
		_duration = new_duration
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
	_time_left = _duration
	_state = TimerState.INITED


## we say if the timer can be removed
func is_ready_for_cleanup() -> bool:
	return _state == TimerState.READY_TO_CLEANUP


## we say if the timer is running
func is_running() -> bool:
	return _state == TimerState.RUNNING


## we say if the timer is not running
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


## marks the timer for removal; the manager drops it on its next tick
## (never erase it from the list directly, it could be mid-iteration)
func cancel() -> void:
	_prepare_for_cleanup()


## we stop the timer momentarily
func _stop_timer() -> void:
	stop()


# if it's looping we start the timer again and if it's not then we free the timer
func _handle_no_time_left() -> void:
	match _mode:
		# if it's looping, we need to restart the loop
		TimerMode.LOOP:
			_restart_by_loop()
		# if it's manual, we just stop the timer and wait for the user to start it again
		TimerMode.MANUAL:
			_stop_timer()
		# if it's one shot, we prepare it for cleanup
		TimerMode.ONE_SHOT:
			_prepare_for_cleanup()
