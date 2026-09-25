extends Node3D
class_name Weapon


## the event used to request timers needed by this weapon's shooting cost strategy
@export var _on_timer_requested : BaseEvent

var _weapon_config : WeaponConfig
var _shooting_cost_config : ShootingCostConfig
var _projectile_config : ProjectileConfig


## the shooting cost strategy instance
var _current_shooting_cost_strategy : ShootingCostStrategy

## this weapon's visual mesh, carrying its own muzzle
var _weapon_mesh : Node3D
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
	_current_shooting_cost_strategy.configure(_shooting_cost_config, self, _on_timer_requested)


## instantiates this weapon's visual mesh, tints it and takes its muzzle from it
func _mount_weapon_mesh(config: WeaponConfig) -> void:
	_weapon_mesh = config.weapon_mesh_scene.instantiate() as Node3D
	add_child(_weapon_mesh)
	_muzzle = _weapon_mesh.get_node("%Muzzle") as Marker3D
	_tint_weapon_mesh(config.weapon_color)


## duplicates the material first since it's a sub-resource shared by every
## instance of weapon_mesh_scene (same reasoning as EntityLevelConfig.entity_color)
func _tint_weapon_mesh(color: Color) -> void:
	var mesh_instance : MeshInstance3D = _weapon_mesh as MeshInstance3D
	var material : StandardMaterial3D = (mesh_instance.get_surface_override_material(0) as StandardMaterial3D).duplicate()
	material.albedo_color = color
	mesh_instance.set_surface_override_material(0, material)


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
