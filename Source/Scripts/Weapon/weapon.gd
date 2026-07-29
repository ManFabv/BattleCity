extends Resource
class_name Weapon

## the current shooting cost strategy
@export var _shooting_cost_strategy : ShootingCostStrategy:
	get:
		return _shooting_cost_strategy
	set(new_value):
		_shooting_cost_strategy = new_value


## projectile scene to instantiate
@export var projectile_scene : PackedScene:
	get():
		return projectile_scene
	set(new_value):
		projectile_scene = new_value


## we update the weapon status
func process_weapon(_delta: float) -> void:
	# we update the shooting cost strategy
	_shooting_cost_strategy.process_cost(_delta)


## we ask the shooting cost strategy if we can shoot or not
func can_shot() -> bool:
	push_error("can_shot() should be implemented on inherited classes")
	return false


## the weapon will handle the shot, instantiating the projectile and firing it
func try_shot(_muzzle: Marker3D, _node_to_attach_to: Node) -> void:
	push_error("try_shot() should be implemented on inherited classes")


## for cleanup
func remove_weapon() -> void:
	push_error("remove_weapon() should be implemented on inherited classes")


## we initialize the weapon stats and the shooting cost strategy
func initialize() -> void:
	_shooting_cost_strategy = _shooting_cost_strategy.duplicate()
	
