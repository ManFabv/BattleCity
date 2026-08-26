extends Node
class_name TimerManager


## event where we are going to subscribe
## to listen when objects need a timer
@export var _request_timer : BaseEvent


## list of current created timers
var _timers : Array[CustomTimer]


## at the begining we subscribe to the event
func _ready() -> void:
	# We start listening to the event
	_request_timer.subscribe(_on_timer_requested, tree_exited)


## we process all the timers and we remove the not needed ones
func _process(delta: float) -> void:
	# we take the amount of timers
	var timers_count : int = _timers.size()
	# if we don't have any timer we return earlier
	if timers_count <= 0:
		return
	# we made a reverse loop so we can remove timers safely
	for i in range(timers_count - 1, -1, -1):
		# we cache the current timer
		var timer : CustomTimer = _timers[i]
		# we tick the timer
		timer.tick(delta)
		# if it's ready to be removed, we remove it
		# It won't crash because of the reverse loop
		if timer.is_ready_for_cleanup():
			# because the timer is ref counted, removing them from
			# the array should be enough so the engine removes it
			_timers.remove_at(i)


## method called for the other nodes when they need a timer
func _on_timer_requested(timer_context: TimerContext) -> void:
	# if the instance is valid
	if is_instance_valid(timer_context):
		# we create the timer
		var timer : CustomTimer = CustomTimer.new(timer_context)
		# we add the timer and start it
		_add_and_start(timer)
		# we listen if the requester is freed
		# when the requester leaves the tree, we drop this timer from the list
		# we use bind so we can cache the timer reference
		timer_context.on_owner_freed.connect(_remove_timer_requested.bind(timer), CONNECT_ONE_SHOT)


## we add the timer and we start it
func _add_and_start(timer: CustomTimer) -> void:
	_timers.append(timer)
	timer.start()


## remove a timer that is no longer needed (owner destroyed or already gone)
func _remove_timer_requested(timer: CustomTimer) -> void:
	_timers.erase(timer)
