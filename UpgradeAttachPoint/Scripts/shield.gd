class_name Shield
extends Area3D

@export_group("References")
## particles orbiting the shielded entity
@export var _orbit_particles : CPUParticles3D
## the shared timer manager used to request the timer that removes this shield after _duration
@export var _timer_manager : TimerManagerResource
@export_group("FX Config")
## how long the shield stays attached before removing itself
@export_range(0.1, 60.0) var _duration : float = 5.0
## how fast the particles orbit, in radians per second
@export_range(0.1, 20.0) var _orbit_speed : float = 2.0


## we connect the timer effect and request the timer to remove this shield after _duration
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	_timer_manager.create_one_shot(_duration, queue_free, tree_exited)


## rotates the orbit particles around the shielded entity
func _process(delta: float) -> void:
	_orbit_particles.rotate_y(_orbit_speed * delta)


## the collision mask only lets enemy projectiles reach this callback
func _on_area_entered(projectile: Projectile) -> void:
	# we intercept the projectile to prevent it from hitting the shielded entity
	projectile.intercept()
