class_name Weapon
extends Node3D
## a weapon type is a scene with its barrels; a shot fires one projectile per muzzle

@export_group("Events")
## the event where we notify that a projectile should be added to the tree
@export var _on_projectile_spawned : BaseEvent

@export_group("References")
## the shared timer manager the cooldown between shots is requested from
@export var _timer_manager : TimerManagerResource
## the meshes of this weapon, tinted with the weapon color
@export var _tinted_meshes : Array[TintedMesh]
## where each projectile of a shot spawns from, one per barrel; their forward axis is the firing direction
@export var _muzzles : Array[Marker3D]

## config of this weapon, set on configure
var _weapon_config : WeaponConfig
## color of the weapon meshes and of the projectiles it fires, set by apply_color()
var _weapon_color : Color = Color.WHITE
## cooldown between shots, restarted manually on every shot
var _fire_rate_timer : CustomTimer
## true once the cooldown elapsed, so the next shot is allowed
var _is_fire_rate_ready : bool = true


## we request the cooldown once, not started so the first shot is allowed right away; it is cleaned up with this weapon
func _ready() -> void:
	_fire_rate_timer = _timer_manager.create_manual(_weapon_config.fire_rate_seconds, _on_fire_rate_timer_timeout, tree_exited)


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


## shoots if the cooldown elapsed and returns true when a shot was fired
func try_shot() -> bool:
	# we can't shoot until the cooldown elapsed
	if not _is_fire_rate_ready:
		return false
	# we consume the shot
	_is_fire_rate_ready = false
	# the cooldown counts from this shot
	_fire_rate_timer.start()
	# one projectile per muzzle
	for muzzle in _muzzles:
		_fire_projectile(muzzle)
	return true


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
				_weapon_config.projectile_speed,
				_weapon_config.projectile_damage_points,
				_weapon_config.projectile_lifetime_seconds)
		# we fire it along the muzzle forward axis
		projectile.fire(muzzle.global_transform.basis.z)
	else:
		# we report the misconfigured weapon config
		push_error("projectile_scene of %s is not a Projectile scene" % _weapon_config.resource_path)
		# a node outside the tree is not reference counted, so nobody else would free it
		instance.free()


## the cooldown elapsed, so the next shot is allowed
func _on_fire_rate_timer_timeout() -> void:
	_is_fire_rate_ready = true
