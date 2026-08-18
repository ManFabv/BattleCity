extends Node
class_name Weapon


## the current shooting cost strategy scene
@export var _shooting_cost_strategy_scene : PackedScene

## projectile scene to instantiate
@export var _projectile_scene : PackedScene

## movement strategy scene injected into the projectile when fired
@export var _continuous_movement_scene : PackedScene


## the shooting cost strategy instance
var _current_shooting_cost_strategy : ShootingCostStrategy


## the initialize the weapon when it is added to the scene
func _ready() -> void:
	_current_shooting_cost_strategy = _shooting_cost_strategy_scene.instantiate() as ShootingCostStrategy
	add_child(_current_shooting_cost_strategy)


## we update the weapon status
func process_weapon(_delta: float) -> void:
	# we update the shooting cost strategy
	_current_shooting_cost_strategy.process_cost(_delta)


## we ask the shooting cost strategy if we can shoot or not
func can_shot() -> bool:
	return _current_shooting_cost_strategy.can_shot()


## we release the weapon resources
func release_weapon() -> void:
	_current_shooting_cost_strategy.queue_free()
	queue_free()


## the weapon will handle the shot, instantiating the projectile and firing it
func try_shot(_muzzle: Marker3D, _on_projectile_spawned: BaseEvent) -> void:
	push_error("try_shot() should be implemented on inherited classes")
