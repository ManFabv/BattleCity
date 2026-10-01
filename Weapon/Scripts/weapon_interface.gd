extends Node3D
class_name WeaponInterface


@export_group("References")
## the shared timer manager used to request timers needed by this weapon's shooting cost strategy
@export var _timer_manager : TimerManagerResource

var _weapon_config : WeaponConfig
var _shooting_cost_config : ShootingCostConfigInterface
var _projectile_config : ProjectileConfig


## the shooting cost strategy instance
var _current_shooting_cost_strategy : ShootingCostStrategyInterface

## this weapon's visual mesh, carrying its own muzzle
var _weapon_mesh : WeaponMesh
## where this weapon's projectiles spawn from; taken from the weapon mesh above
var _muzzle : Marker3D


func configure(config: WeaponConfig) -> void:
	_weapon_config = config
	_projectile_config = config.projectile_config
	_shooting_cost_config = config.shooting_cost_config
	_mount_weapon_mesh(config)


## the initialize the weapon when it is added to the scene
func _ready() -> void:
	_current_shooting_cost_strategy = _shooting_cost_config.create_strategy()
	_current_shooting_cost_strategy.configure(_shooting_cost_config, self, _timer_manager)


## instantiates this weapon's visual mesh, tints it and takes its muzzle from it
func _mount_weapon_mesh(config: WeaponConfig) -> void:
	_weapon_mesh = config.weapon_mesh_scene.instantiate() as WeaponMesh
	add_child(_weapon_mesh)
	_muzzle = _weapon_mesh.muzzle
	_weapon_mesh.apply_color(config.weapon_color)


## we update the weapon status
func process_weapon(_delta: float) -> void:
	# we update the shooting cost strategy
	_current_shooting_cost_strategy.process_cost(_delta)


## we ask the shooting cost strategy if we can shoot or not
func can_shot() -> bool:
	return _current_shooting_cost_strategy.can_shot()


## we release the weapon resources
func release_weapon() -> void:
	queue_free()


## the weapon will handle the shot, instantiating the projectile and firing it
func try_shot(_on_projectile_spawned: BaseEvent) -> void:
	push_error("try_shot() should be implemented on inherited classes")
