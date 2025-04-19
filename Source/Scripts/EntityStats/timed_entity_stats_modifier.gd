class_name TimedEntityStatsModifier
extends EntityStatsModifier

## how much time this stats modifier will be applied
@export_range(0, 60) var duration : float = 3

#internal timer for deplete stats modifier
var _timer : Timer


## we are going to start a timer for this
func init(owner: Node) -> void:
	_timer = setup_timer()
	owner.add_child(_timer)
	_timer.start()


func setup_timer() -> Timer:
	var timer : Timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = duration
	timer.timeout.connect(_on_timer_timeout)
	return timer


func _on_timer_timeout() -> void:
	on_modifier_depleted.emit(self)
