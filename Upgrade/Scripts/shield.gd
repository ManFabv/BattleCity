class_name Shield
extends Area3D

## how long the shield stays attached before removing itself
@export_range(0.0, 60.0) var _duration : float = 5.0
## particles orbiting the shielded entity; CPUParticles3D instead of GPUParticles3D because the
## project's Compatibility renderer pays a shader-compile hitch on a GPU particle material's first use
@export var _orbit_particles : CPUParticles3D
## how fast the particles orbit, in radians per second
@export var _orbit_speed : float = 2.0


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	var timer_context : CustomTimerContext = CustomTimerContext.create_one_shot(_duration, queue_free, tree_exited)
	CustomTimerContext.request(timer_context)


func _process(delta: float) -> void:
	_orbit_particles.rotate_y(_orbit_speed * delta)


## the collision mask only lets enemy projectiles reach this callback
func _on_area_entered(projectile: Projectile) -> void:
	projectile.intercept()
