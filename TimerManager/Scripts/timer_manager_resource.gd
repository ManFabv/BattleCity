class_name TimerManagerResource
extends Resource

## list of current created timers
var _timers : Array[CustomTimer]


## ticks every timer and drops the finished or cancelled ones; a single CustomTimerManager drives it
func tick(delta: float) -> void:
	# we take the amount of timers
	var timers_count : int = _timers.size()
	# if we don't have any timer we return earlier
	if timers_count <= 0:
		return
	# reverse loop: removing shifts nothing we still visit, and timers created in a callback go to the end
	for i in range(timers_count - 1, -1, -1):
		var timer : CustomTimer = _timers[i]
		timer.tick(delta)
		if timer.is_ready_for_cleanup():
			_timers.remove_at(i)


## create a one shot timer, after timeout it's ready to cleanup
func create_one_shot(duration: float, on_timeout: Callable, owner_exited: Signal, auto_start: bool = true) -> CustomTimer:
	return _create(duration, CustomTimer.TimerMode.ONE_SHOT, on_timeout, owner_exited, auto_start)


## create a looping timer, it will restart automatically
## TODO: for periodic effects such as a blinking power-up or a spawner wave
func create_loop(duration: float, on_timeout: Callable, owner_exited: Signal, auto_start: bool = true) -> CustomTimer:
	return _create(duration, CustomTimer.TimerMode.LOOP, on_timeout, owner_exited, auto_start)


## create a manual timer, stopped by default: the owner starts and restarts it with start()
func create_manual(duration: float, on_timeout: Callable, owner_exited: Signal, auto_start: bool = false) -> CustomTimer:
	return _create(duration, CustomTimer.TimerMode.MANUAL, on_timeout, owner_exited, auto_start)


## creates the timer, keeps it ticking until its owner leaves the tree and starts it if asked
func _create(duration: float, mode: CustomTimer.TimerMode, on_timeout: Callable, owner_exited: Signal, auto_start: bool) -> CustomTimer:
	# we create the timer with its callback
	var timer : CustomTimer = CustomTimer.new(duration, mode, on_timeout)
	# the list keeps it alive and ticking
	_timers.append(timer)
	# when the owner leaves the tree we only mark the timer, tick() removes it
	owner_exited.connect(timer.cancel, CONNECT_ONE_SHOT)
	# we start it right away if asked
	if auto_start:
		timer.start()
	return timer
