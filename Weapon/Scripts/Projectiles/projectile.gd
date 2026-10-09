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

## direction the projectile moves, set when it's fired
var _move_direction : Vector3 = Vector3.FORWARD
## units per second the projectile moves, set on configure
var _projectile_max_speed : float = 0.0:
	set(new_value):
		# we prevent negative values, which would move the projectile backwards
		_projectile_max_speed = maxf(new_value, 0.0)


## to avoid having to connect this signal on every node, we connect it here
func _ready() -> void:
	# we are destroyed after dealing damage
	_hurt_entity.subscribe_to_damage_dealt(_destroy_projectile)
	# we listen to the bodies we hit
	body_shape_entered.connect(_on_body_shape_entered)
	# we are destroyed once we leave the screen
	_visible_on_screen_notifier.screen_exited.connect(_destroy_projectile)


## we move the projectile along its direction
func _physics_process(delta: float) -> void:
	# only the origin changes, so we don't rebuild the whole transform
	global_position += _move_direction * _projectile_max_speed * delta


## tints the projectile, caches its speed and damage and starts its lifetime; called once it's in the tree
func configure(projectile_color: Color, projectile_max_speed: float, projectile_damage_points: int, projectile_lifetime_seconds: float) -> void:
	# we tint the projectile with the color of whoever fired it
	_mesh.apply_color(projectile_color)
	# we cache the speed so the physics step only reads members
	_projectile_max_speed = projectile_max_speed
	# we set the damage the hurt area deals
	_hurt_entity.configure(projectile_damage_points)
	# a shot spawned off screen never gets screen_exited, so its lifetime timer removes it
	_timer_manager.create_one_shot(projectile_lifetime_seconds, _destroy_projectile, tree_exited)


## places the projectile and sets the direction it moves
func fire(spawn_position: Vector3, move_direction: Vector3) -> void:
	# we place the projectile where the shooter spawns it
	global_position = spawn_position
	# we normalize once here so the physics step doesn't have to
	_move_direction = move_direction.normalized()


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
