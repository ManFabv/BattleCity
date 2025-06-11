class_name EntityState
extends Node

## an array of possible transitions from this state to another
@export var _transitions: Array[StateTransition]

## if we met any condition, we will cache here the new state
var _current_next_state_to_transition: EntityState


# executed at the begin of the new state change
func enter(_owner_controllable_entity : ControllableEntity) -> void:
	push_error("enter() should be implemented on inherited classes")


# executed before changing to the new state change
func exit() -> void:
	push_error("exit() should be implemented on inherited classes")


# updated at every frame
func update(_delta: float) -> void:
	push_error("update() should be implemented on inherited classes")


# updated at fixed steps
func physics_update(_delta: float) -> void:
	push_error("physics_update() should be implemented on inherited classes")


# this will tell us if any transition condition is met
func can_transition() -> bool:
	for transition in _transitions:
		if transition.can_transition():
			_current_next_state_to_transition = transition.next_state
			return true
	return false


# this will return the new state where we have to change after the condition is met
func get_new_state_to_transition() -> EntityState:
	return _current_next_state_to_transition
