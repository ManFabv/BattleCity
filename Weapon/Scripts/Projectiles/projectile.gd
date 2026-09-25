class_name Projectile
extends Area3D


## Strategy responsible for moving the projectile
var _projectile_movement_strategy: ProjectileMovementStrategy

## true once this projectile resolved a hit on the level grid, so a shot touching
## two cells at once (e.g. on the seam between them) only breaks one
var _has_hit_level_grid: bool = false

# reference to the component
@onready var _hurt_entity: Hurt = %Hurt


## to avoid having to connect this signal on
## every node, we connect it here
func _ready() -> void:
	_hurt_entity.subscribe_to_damage_signal(_destroy_projectile)
	# shape-level signal, needed so LevelGrid hits resolve the exact cell hit
	body_shape_entered.connect(_on_body_shape_entered)


## we fire the projectile and fire it, setting the position and movement strategy
func fire(shoot_point: Marker3D, projectile_config: ProjectileConfig) -> void:
	# we set the position to be at the muzzle
	global_position = shoot_point.global_position
	_hurt_entity.configure(projectile_config.damage_stats)
	# initialize the projectile movement strategy
	_projectile_movement_strategy = projectile_config.projectile_movement_stats.create_strategy()
	_projectile_movement_strategy.configure(projectile_config.projectile_movement_stats, shoot_point)


## we move the projectile on the forward direction
func _physics_process(delta: float) -> void:
	global_transform = _projectile_movement_strategy.move(global_transform, delta)


## we hit solid world geometry (World/Floor/LevelBlocks): destroy the projectile
func _on_body_entered(_body: Node3D) -> void:
	_destroy_projectile()


## if we hit the level's block grid, resolve the destructible block at the exact
## shape we hit -- asking the physics server which cell that shape belongs to,
## instead of guessing a cell from our own position
func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, _local_shape_index: int) -> void:
	var level_grid := body as LevelGrid
	if level_grid and not _has_hit_level_grid:
		_has_hit_level_grid = true
		level_grid.resolve_hit_from_shape(body_rid, body_shape_index)


## called by a shield that intercepts this projectile
func intercept() -> void:
	_destroy_projectile()


## here we check if the projectile left the screen to remove it
## this is done using the VisibleOnScreenNotifier3D node
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	# we only need to remove the projectile
	queue_free()


## for now we only remove the node from the tree
## but we can spawn particles, play sound, etc
func _destroy_projectile() -> void:
	queue_free()
