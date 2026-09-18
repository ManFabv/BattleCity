extends Node
class_name Weapon


var _weapon_config : WeaponConfig
var _shooting_cost_config : ShootingCostConfig
var _projectile_config : ProjectileConfig


## the shooting cost strategy instance
var _current_shooting_cost_strategy : ShootingCostStrategy


func configure(config: WeaponConfig) -> void:
	_weapon_config = config
	_projectile_config = config.projectile_config
	_shooting_cost_config = config.shooting_cost_config


## the initialize the weapon when it is added to the scene
func _ready() -> void:
	_current_shooting_cost_strategy = TimedShootingCostStrategy.new()
	_current_shooting_cost_strategy.configure(_shooting_cost_config, self)


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
func try_shot(_muzzle: Marker3D, _on_projectile_spawned: BaseEvent) -> void:
	push_error("try_shot() should be implemented on inherited classes")
