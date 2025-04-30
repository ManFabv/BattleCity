class_name TimedEntityStatsModifier
extends EntityStatsModifier

## how much time this stats modifier will be applied
@export_range(0, 60) var duration : float = 3

## internal timer for deplete this stats modifier
var _timer : Timer


## we are going to start a timer for this
func init(owner: Node) -> void:
	# we create an initialize the timer
	setup_timer()
	# we add it to the scene tree as child of the stats modifier owner
	owner.add_child(_timer)
	# we start the timer
	_timer.start()

## here we create and set the signals for the timer
func setup_timer() -> void:
	_timer = Timer.new()
	# modifier should be used only once
	_timer.one_shot = true
	_timer.wait_time = duration
	# we connect the timeout signal to let our nodes know when modifier is depleted
	_timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	# we trigger the notification that this modifier is depleted
	on_modifier_depleted.emit(self)
	# we remove the timer
	_timer.queue_free()
