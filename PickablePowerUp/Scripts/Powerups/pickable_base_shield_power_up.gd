class_name PickableBaseShieldPowerUp
extends PickablePowerUpInterface

## shield scene attached to the base on pickup
@export var _shield_scene : PackedScene
## event we listen to in order to know the base this power-up protects
@export var _on_base_spawned : BaseEvent

## the base this power-up protects, set when the base spawns
var _base : Base


func _ready() -> void:
	# we run the ready of the parent
	super._ready()
	# we also listen to the on base spawned
	_on_base_spawned.subscribe(_on_base_spawned_handler, tree_exited)


## when the base is spawned we grab de reference
func _on_base_spawned_handler(base: Base) -> void:
	if is_instance_valid(base):
		_base = base


func _apply_pickup(_picker: ControllableEntity) -> void:
	# the base may have already been destroyed while this power-up was still in the level
	if is_instance_valid(_base):
		var shield = _shield_scene.instantiate() as Shield
		_base.attach_upgrade(shield)
