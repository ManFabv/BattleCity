extends Node
class_name Weapon


## the current shooting cost strategy scene
@export var _shooting_cost_strategy_scene : PackedScene

## projectile scene to instantiate
@export var projectile_scene : PackedScene

## movement strategy scene injected into the projectile when fired
@export var continuous_movement_scene : PackedScene


## the shooting cost strategy instance
var _shooting_cost_strategy : ShootingCostStrategy


## we update the weapon status
func process_weapon(_delta: float) -> void:
	# we update the shooting cost strategy
	_shooting_cost_strategy.process_cost(_delta)


## we ask the shooting cost strategy if we can shoot or not
func can_shot() -> bool:
	return _shooting_cost_strategy.can_shot()


## we initialize the needed variables for the weapon
func setup_weapon(_owner: Node) -> void:
	_shooting_cost_strategy = _shooting_cost_strategy_scene.instantiate() as ShootingCostStrategy
	_owner.add_child(_shooting_cost_strategy)


## we release the weapon resources
func release_weapon() -> void:
	_shooting_cost_strategy.queue_free()
	queue_free()


## the weapon will handle the shot, instantiating the projectile and firing it
func try_shot(_muzzle: Marker3D, _on_projectile_spawned: BaseEvent) -> void:
	push_error("try_shot() should be implemented on inherited classes")
