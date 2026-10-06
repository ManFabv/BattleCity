class_name Projectile
extends Area3D

## reference to the component
@onready var _hurt_entity: Hurt = %Hurt
## the projectile mesh, tinted with the color of the weapon that fires it
@onready var _mesh: TintedMesh = %TintedMesh

## Strategy responsible for moving the projectile
var _projectile_movement_strategy: ProjectileMovementStrategyInterface


## to avoid having to connect this signal on every node, we connect it here
func _ready() -> void:
	_hurt_entity.subscribe_to_damage_signal(_destroy_projectile)
	body_shape_entered.connect(_on_body_shape_entered)


## we move the projectile on the forward direction
func _physics_process(delta: float) -> void:
	global_transform = _projectile_movement_strategy.move(global_transform, delta)


## we fire the projectile and fire it, setting the position and movement strategy
func fire(shoot_point: Marker3D, projectile_config: ProjectileConfig, color: Color) -> void:
	_mesh.apply_color(color)
	# we set the position to be at the muzzle
	global_position = shoot_point.global_position
	# we configure the hurt node
	_hurt_entity.configure(projectile_config.damage_stats)
	# initialize the projectile movement strategy
	_projectile_movement_strategy = projectile_config.projectile_movement_stats.create_strategy()
	# we configure the movement strategy
	_projectile_movement_strategy.configure(projectile_config.projectile_movement_stats, shoot_point)


## this will tell us that we should destroy this projectile
func intercept() -> void:
	_destroy_projectile()


## for now we only remove the node from the tree but we can spawn particles, play sound, etc
func _destroy_projectile() -> void:
	queue_free()


## we hit solid geometry: if it's a destructible grid we break the block of the shape we hit,
## in any case the projectile is destroyed
func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, _local_shape_index: int) -> void:
	# we only break blocks if the body is a destructible grid
	var destructible_grid_map : DestructibleGridMap = body as DestructibleGridMap
	if is_instance_valid(destructible_grid_map):
		# we break the block of the shape we hit
		destructible_grid_map.destroy_block_from_shape(body_rid, body_shape_index)
	# if two shapes are touched at once (a seam) this runs twice: queue_free() twice is harmless
	_destroy_projectile()


## here we check if the projectile left the screen to remove it
## this is done using the VisibleOnScreenNotifier3D node
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	# we only need to remove the projectile
	queue_free()
