class_name WeaponSystem
extends Node

## Weapon stats like velocity and damage
@export var _weapon_stats : WeaponStats

# this timer will reset the variable that allow us to shot 
@onready var _fire_rate_timer: Timer = $FireRateTimer

# this will be enabled every time the timer timeouts
var _can_shot : bool = false


func _ready() -> void:
	# we set the wait time for the timer as the fire rate
	_fire_rate_timer.wait_time = _weapon_stats.fire_rate
	# we start the timer
	_fire_rate_timer.start()


func process_shot(has_shot : bool, muzzle: Marker3D) -> void:
	if has_shot and _can_shot:
		# we instantiate the projectile
		var shot = _weapon_stats.projectile_scene.instantiate() as Projectile
		# we add the shot to the scene (after this ready function will be triggered)
		add_child(shot)
		# we fire the shot
		shot.fire(muzzle)
		# we reset the timer
		restart_timer()


# we need to stop and start again to restart
func restart_timer() -> void:
	# we say we cant shot after the timer resets
	_can_shot = false
	_fire_rate_timer.stop()
	_fire_rate_timer.start()


# we the time ends, we say that we can shot again
func _on_fire_rate_timer_timeout() -> void:
	_can_shot = true
