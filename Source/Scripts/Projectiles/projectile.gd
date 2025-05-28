class_name Projectile
extends Area3D

## Damage stats like damage
@export var _damage_stats : DamageStats
## Projectile stats like velocity
@export var _projectile_stats: ProjectileStats

# reference to the component
@onready var _hurt_entity: Hurt = $Hurt

## direction where the projectile is moving
var direction : Vector3 = Vector3.FORWARD


func _ready() -> void:
	# we setup the hurt area
	_hurt_entity.configure(_damage_stats, _destroy_projectile)


## we configure the projectile
func fire(shoot_point: Marker3D) -> void:
	# we set the position to be at the muzzle
	global_position = shoot_point.global_position
	# we take the muzzle forward position
	direction = shoot_point.global_transform.basis.z


## we move the projectile on the forward direction
func _physics_process(delta: float) -> void:
	position += direction * _projectile_stats.speed * delta


## here we check if the projectile left the screen to remove it
## this is done using the VisibleOnScreenNotifier3D node
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	# we only need to remove the projectile
	queue_free()


## for now we only remove the node from the tree
## but we can spawn particles, play sound, etc
func _destroy_projectile() -> void:
	queue_free()


func _on_body_entered(_body: Node3D) -> void:
	#we destroy the projectile after it collides with anything
	_destroy_projectile()
