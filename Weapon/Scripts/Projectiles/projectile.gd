class_name Projectile
extends Area3D

@export_group("References")
## the area that deals this projectile's damage to the health it touches
@export var _hurt_entity: Hurt
## the projectile mesh, tinted with the color of the weapon that fires it
@export var _mesh: TintedMesh
## reports when the projectile leaves the screen
@export var _visible_on_screen_notifier : VisibleOnScreenNotifier3D
## the shared timer manager used to request the lifetime timer
@export var _timer_manager : TimerManagerResource

## how this projectile moves, created from the movement config on configure
var _projectile_movement : ProjectileMovementInterface


## to avoid having to connect this signal on every node, we connect it here
func _ready() -> void:
	# we are destroyed after dealing damage
	_hurt_entity.subscribe_to_damage_dealt(_destroy_projectile)
	# we listen to the bodies we hit
	body_shape_entered.connect(_on_body_shape_entered)
	# we are destroyed once we leave the screen
	_visible_on_screen_notifier.screen_exited.connect(_destroy_projectile)


## we move the projectile as its movement says
func _physics_process(delta: float) -> void:
	# only the position changes, so we don't rebuild the whole transform
	global_position = _projectile_movement.move(global_position, delta)


## tints the projectile, creates its movement, sets its damage and starts its lifetime; called once it's in the tree
func configure(projectile_color: Color, projectile_movement_config: ProjectileMovementConfig, projectile_damage_points: int, projectile_lifetime_seconds: float) -> void:
	# we tint the projectile with the color of whoever fired it
	_mesh.apply_color(projectile_color)
	# we keep the movement of this projectile
	_projectile_movement = projectile_movement_config.create_projectile_movement()
	# we set the damage the hurt area deals
	_hurt_entity.configure(projectile_damage_points)
	# a shot spawned off screen never gets screen_exited, so its lifetime timer removes it
	_timer_manager.create_one_shot(projectile_lifetime_seconds, _destroy_projectile, tree_exited)


## sets the direction it moves; the shooter placed it before it entered the tree
func fire(move_direction: Vector3) -> void:
	# the movement keeps the direction it follows
	_projectile_movement.aim(move_direction)


## this will tell us that we should destroy this projectile
func intercept() -> void:
	_destroy_projectile()


## for now we only remove the node from the tree but we can spawn particles, play sound, etc
func _destroy_projectile() -> void:
	queue_free()


## the body is a StaticBody3D (World, Base) or a GridMap (LevelBlocks); bricks break, the projectile always dies
func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, _local_shape_index: int) -> void:
	# we only break blocks if the body is a destructible grid
	var destructible_grid_map : DestructibleGridMap = body as DestructibleGridMap
	if is_instance_valid(destructible_grid_map):
		# we break the block of the shape we hit
		destructible_grid_map.destroy_block_from_shape(body_rid, body_shape_index)
	# if two shapes are touched at once (a seam) this runs twice: queue_free() twice is harmless
	_destroy_projectile()
