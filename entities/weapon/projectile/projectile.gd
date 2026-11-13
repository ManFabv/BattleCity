class_name Projectile
extends Area3D

@export_group("References")
## the area that deals this projectile's damage to the health it touches
@export var _hurt : Hurt
## the projectile mesh, tinted with the color of the weapon that fires it
@export var _tinted_mesh : TintedMesh
## reports when the projectile leaves the screen
@export var _visible_on_screen_notifier : VisibleOnScreenNotifier3D
## the shared timer manager used to request the lifetime timer
@export var _timer_manager : TimerManagerResource

## units per second the projectile moves, set on configure
var _speed : float = 0.0
## unit direction the projectile moves along, set on fire
var _move_direction : Vector3 = Vector3.FORWARD


## to avoid having to connect this signal on every node, we connect it here
func _ready() -> void:
	# we are destroyed after dealing damage
	_hurt.subscribe_to_damage_dealt(_destroy_projectile)
	# we listen to the bodies we hit
	body_shape_entered.connect(_on_body_shape_entered)
	# we are destroyed once we leave the screen
	_visible_on_screen_notifier.screen_exited.connect(_destroy_projectile)


## we move the projectile in a straight line
func _physics_process(delta: float) -> void:
	# only the position changes, so we don't rebuild the whole transform
	global_position += _move_direction * _speed * delta


## tints the projectile, sets its speed and damage and starts its lifetime; called once it's in the tree
func configure(projectile_color: Color, projectile_speed: float, projectile_damage_points: int, projectile_lifetime_seconds: float) -> void:
	# we tint the projectile with the color of whoever fired it
	_tinted_mesh.apply_color(projectile_color)
	# we cache the speed the physics tick reads
	_speed = projectile_speed
	# we set the damage the hurt area deals
	_hurt.configure(projectile_damage_points)
	# a shot spawned off screen never gets screen_exited, so its lifetime timer removes it
	_timer_manager.create_one_shot(projectile_lifetime_seconds, _destroy_projectile, tree_exited)


## sets the direction it moves; the shooter placed it before it entered the tree
func fire(move_direction: Vector3) -> void:
	# we normalize the direction once here, so the physics tick doesn't have to
	_move_direction = move_direction.normalized()


## a shield stopped this projectile, it must not hurt even if it already touched a health in this physics step
func intercept() -> void:
	# we cancel the damage first
	_hurt.disarm()
	# we remove the projectile
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
