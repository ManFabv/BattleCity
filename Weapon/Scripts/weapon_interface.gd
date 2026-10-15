class_name WeaponInterface
extends Node3D

@export_group("Events")
## the event where we notify that a projectile should be added to the tree
@export var _on_projectile_spawned : BaseEvent
@export_group("References")
## the shared timer manager the shot cost requests its timers from
@export var _timer_manager : TimerManagerResource

## config of this weapon, set on configure
var _weapon_config : WeaponConfig
## color of the weapon mesh and of the projectiles it fires, set by apply_color()
var _weapon_color : Color = Color.WHITE
## this weapon's visual mesh, carrying its own muzzle
var _weapon_mesh : WeaponMesh
## where this weapon's projectiles spawn from; the mesh's muzzle, or this weapon if the mesh is invalid
var _muzzle : Node3D
## what a shot costs, created from the config; it decides when the weapon can shoot
var _shot_cost : ShotCostInterface


## we create the shot cost once, it is cleaned up when this weapon leaves the tree
func _ready() -> void:
	# we keep the cost of this weapon
	_shot_cost = _weapon_config.shot_cost_config.create_shot_cost(_timer_manager, tree_exited)


## we cache the config and mount the weapon mesh; called before the weapon enters the tree
func configure(weapon_config: WeaponConfig) -> void:
	# we cache the config every shot reads from
	_weapon_config = weapon_config
	# we mount the visual mesh and take its muzzle
	_mount_weapon_mesh()


## tints the weapon mesh and the projectiles fired from now on
func apply_color(color: Color) -> void:
	# we cache the color the projectiles take
	_weapon_color = color
	# a weapon without a valid mesh has nothing to tint
	if is_instance_valid(_weapon_mesh):
		# we tint the mesh
		_weapon_mesh.apply_color(color)


## shoots if the shot cost can be paid and returns true when a shot was fired
func try_shot() -> bool:
	# we can't shoot until the cost can be paid
	if not _shot_cost.can_shoot():
		return false
	# we charge the cost only when we actually shoot
	_shot_cost.consume()
	# each weapon type decides which projectiles the shot fires
	_fire_projectiles()
	return true


## instantiates this weapon's visual mesh and takes its muzzle from it
func _mount_weapon_mesh() -> void:
	# we instantiate the mesh untyped, so we can still free it if its root isn't a WeaponMesh
	var instance : Node = _weapon_config.weapon_mesh_scene.instantiate()
	# we cast it to the mesh type that carries the muzzle
	_weapon_mesh = instance as WeaponMesh
	# only a WeaponMesh has a muzzle to fire from
	if is_instance_valid(_weapon_mesh):
		# we parent it here so it follows the entity
		add_child(_weapon_mesh)
		# we cache the muzzle the projectiles spawn from
		_muzzle = _weapon_mesh.muzzle
	else:
		# we report the misconfigured weapon config
		push_error("weapon_mesh_scene of %s is not a WeaponMesh scene" % _weapon_config.resource_path)
		# a node outside the tree is not reference counted, so nobody else would free it
		instance.free()
		# the weapon still fires, from its own position
		_muzzle = self


## fires the projectiles of one shot, each weapon type implements it
func _fire_projectiles() -> void:
	push_error("_fire_projectiles() should be implemented on inherited classes")


## instantiates one projectile, adds it to the tree and fires it from the given position along the muzzle
func _fire_projectile(spawn_position: Vector3) -> void:
	# we instantiate the projectile untyped, so we can still free it if its root isn't a Projectile
	var instance : Node = _weapon_config.projectile_scene.instantiate()
	# we cast it to the type the shot configures
	var projectile : Projectile = instance as Projectile
	# only a Projectile can be configured and fired
	if is_instance_valid(projectile):
		# the listeners add it to the tree, so its _ready() runs before configure()
		_on_projectile_spawned.emit(projectile)
		# we configure it with the weapon values
		projectile.configure(
				_weapon_color,
				_weapon_config.projectile_movement_config,
				_weapon_config.projectile_damage_points,
				_weapon_config.projectile_lifetime_seconds)
		# we fire it along the muzzle forward axis
		projectile.fire(spawn_position, _muzzle.global_transform.basis.z)
	else:
		# we report the misconfigured weapon config
		push_error("projectile_scene of %s is not a Projectile scene" % _weapon_config.resource_path)
		# a node outside the tree is not reference counted, so nobody else would free it
		instance.free()

