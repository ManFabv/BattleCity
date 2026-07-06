extends ContinuousMovementStrategy
class_name LinearContinuousMovementStrategy

## direction where the projectile is moving
var direction : Vector3 = Vector3.FORWARD


## here we can setup the strategy before use
func initialize(origin: Node3D) -> void:
	# we take the origin (usually the shooting point) forward position
	direction = origin.global_transform.basis.z


## function responsible for handling any continuous movement like projectiles
func update_continuous_movement(delta: float, 
		projectile_stats: ProjectileStats, 
		projectile: Projectile) -> void:
	projectile.position += direction * projectile_stats.speed * delta
