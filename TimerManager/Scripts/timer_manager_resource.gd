class_name TimerManagerResource
extends Resource

## list of current created timers
var _timers : Array[CustomTimer]


## ticks every timer and drops the finished/cancelled ones
## must be driven by a single CustomTimerManager node
func tick(delta: float) -> void:
	# we take the amount of timers
	var timers_count : int = _timers.size()
	# if we don't have any timer we return earlier
	if timers_count <= 0:
		return
	# reverse loop so we can remove timers safely; timers created inside a timeout
	# callback are appended at the end, so they don't shift the indexes we still visit
	for i in range(timers_count - 1, -1, -1):
		var timer : CustomTimer = _timers[i]
		timer.tick(delta)
		if timer.is_ready_for_cleanup():
			_timers.remove_at(i)


## create a one shot timer, after timeout it's ready to cleanup
func create_one_shot(duration: float, on_timeout: Callable, owner_exited: Signal, auto_start: bool = true) -> CustomTimer:
	return _create(duration, CustomTimer.TimerMode.ONE_SHOT, on_timeout, owner_exited, auto_start)


## create a looping timer, it will restart automatically
func create_loop(duration: float, on_timeout: Callable, owner_exited: Signal, auto_start: bool = true) -> CustomTimer:
	return _create(duration, CustomTimer.TimerMode.LOOP, on_timeout, owner_exited, auto_start)


## create a manual timer, the owner restarts it with start()
func create_manual(duration: float, on_timeout: Callable, owner_exited: Signal, auto_start: bool = true) -> CustomTimer:
	return _create(duration, CustomTimer.TimerMode.MANUAL, on_timeout, owner_exited, auto_start)


func _create(duration: float, mode: CustomTimer.TimerMode, on_timeout: Callable, owner_exited: Signal, auto_start: bool) -> CustomTimer:
	var timer : CustomTimer = CustomTimer.new(duration, mode, on_timeout)
	_timers.append(timer)
	# when the owner leaves the tree we only mark the timer, tick() removes it
	owner_exited.connect(timer.cancel, CONNECT_ONE_SHOT)
	if auto_start:
		timer.start()
	return timer
