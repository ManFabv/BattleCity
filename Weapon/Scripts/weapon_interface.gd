class_name WeaponInterface
extends Node3D

@export_group("Events")
## the event where we notify that a projectile should be added to the tree
@export var _on_projectile_spawned : BaseEvent

@export_group("References")
## the shared timer manager the shot cost requests its timers from
@export var _timer_manager : TimerManagerResource
## the meshes of this weapon, tinted with the weapon color
@export var _tinted_meshes : Array[TintedMesh]

## config of this weapon, set on configure
var _weapon_config : WeaponConfig
## color of the weapon meshes and of the projectiles it fires, set by apply_color()
var _weapon_color : Color = Color.WHITE
## what a shot costs, created from the config; it decides when the weapon can shoot
var _shot_cost : ShotCostInterface


## we create the shot cost once, it is cleaned up when this weapon leaves the tree
func _ready() -> void:
	# we keep the cost of this weapon
	_shot_cost = _weapon_config.create_shot_cost(_timer_manager, tree_exited)


## we cache the config every shot reads from; called before the weapon enters the tree
func configure(weapon_config: WeaponConfig) -> void:
	_weapon_config = weapon_config


## tints the weapon meshes and the projectiles fired from now on
func apply_color(color: Color) -> void:
	# we cache the color the projectiles take
	_weapon_color = color
	# each mesh of this weapon shares the material of that color
	for tinted_mesh in _tinted_meshes:
		tinted_mesh.apply_color(color)


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


## fires the projectiles of one shot, each weapon type implements it
func _fire_projectiles() -> void:
	push_error("_fire_projectiles() should be implemented on inherited classes")


## instantiates one projectile, adds it to the tree and fires it from the given muzzle along its forward axis
func _fire_projectile(muzzle: Marker3D) -> void:
	# we instantiate the projectile untyped, so we can still free it if its root isn't a Projectile
	var instance : Node = _weapon_config.projectile_scene.instantiate()
	# we cast it to the type the shot configures
	var projectile : Projectile = instance as Projectile
	# only a Projectile can be configured and fired
	if is_instance_valid(projectile):
		# the container isn't a Node3D, so this is already its global position and it enters the tree in place
		projectile.position = muzzle.global_position
		# the listeners add it to the tree, so its _ready() runs before configure()
		_on_projectile_spawned.emit(projectile)
		# we configure it with the weapon values
		projectile.configure(
				_weapon_color,
				_weapon_config.projectile_movement_config,
				_weapon_config.projectile_damage_points,
				_weapon_config.projectile_lifetime_seconds)
		# we fire it along the muzzle forward axis
		projectile.fire(muzzle.global_transform.basis.z)
	else:
		# we report the misconfigured weapon config
		push_error("projectile_scene of %s is not a Projectile scene" % _weapon_config.resource_path)
		# a node outside the tree is not reference counted, so nobody else would free it
		instance.free()

