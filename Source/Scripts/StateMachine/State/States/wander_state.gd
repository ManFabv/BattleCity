class_name WanderState
extends EntityState

@export_range(0, 10) var _seconds_between_movements : float = 1

## reference to controllable entity that will helps us move across level
var _ai_controller : AIController


# executed at the begin of the new state change
func enter(_owner_controllable_entity : ControllableEntity) -> void:
	# we cache the controller which will allows us to set 
	# different target destinations
	_ai_controller = _owner_controllable_entity._entity_controller
	# we subscribe to the signal because we want to select another destination
	# after reaching the previous position
	_ai_controller.connect_on_target_reached_signal(_set_next_target_position)
	# we set the first target position
	_set_next_target_position()


# executed before changing to the new state change
func exit() -> void:
	pass # nothing at the moment


# updated at every frame
func update(_delta: float) -> void:
	pass # nothing at the moment


# updated at fixed steps
func physics_update(_delta: float) -> void:
	pass # nothing at the moment


# sets the new destination for the entity
func _set_next_target_position() -> void:
	# we first wait to avoid crazy movements of the entity
	await wait(_seconds_between_movements)
	# we then pick a new destination
	_ai_controller.set_random_target_position()


## function that allows us to wait for given seconds
func wait(seconds : float) -> void:
	await get_tree().create_timer(seconds).timeout
