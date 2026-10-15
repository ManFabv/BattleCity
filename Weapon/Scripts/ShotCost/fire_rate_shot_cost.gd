class_name FireRateShotCost
extends ShotCostInterface

## seconds to wait between two shots
var _fire_rate_seconds : float
## cooldown between shots, restarted manually on every shot
var _fire_rate_timer : CustomTimer
## true once the cooldown elapsed, so the next shot is allowed
var _is_fire_rate_ready : bool = true


## we cache the fire rate and request the cooldown timer, not started so the first shot is allowed right away
func _init(fire_rate_shot_cost_config: FireRateShotCostConfig, timer_manager: TimerManagerResource, owner_exited: Signal) -> void:
	# we cache the fire rate so every shot reads a member
	_fire_rate_seconds = fire_rate_shot_cost_config.fire_rate_seconds
	# the timer is cleaned up with the weapon that owns this cost
	_fire_rate_timer = timer_manager.create_manual(_fire_rate_seconds, _on_fire_rate_timer_timeout, owner_exited)


## the weapon can shoot once the cooldown elapsed
func can_shoot() -> bool:
	return _is_fire_rate_ready


## we consume the shot and restart the cooldown only when we actually shoot
func consume() -> void:
	# we consume the shot
	_is_fire_rate_ready = false
	# the cooldown counts from this shot
	_fire_rate_timer.start(_fire_rate_seconds)


## the cooldown elapsed, so the next shot is allowed
func _on_fire_rate_timer_timeout() -> void:
	_is_fire_rate_ready = true
