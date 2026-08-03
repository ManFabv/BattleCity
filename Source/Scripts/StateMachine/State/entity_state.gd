class_name EntityState
extends Node

## this is the signal that will be emitted when we want to change to another state
signal transition_requested(new_state: EntityState)

## the state where we want to transition when the condition is met
@export var _next_state: EntityState:
	get:
		return _next_state
	set(new_value):
		_next_state = new_value


# executed at the begin of the new state change
func enter(_owner_controllable_entity : ControllableEntity) -> void:
	push_error("enter() should be implemented on inherited classes")


# executed before changing to the new state change
func exit() -> void:
	push_error("exit() should be implemented on inherited classes")


# this will notify that we want to change to another state
func request_transition(new_state: EntityState) -> void:
	transition_requested.emit(new_state)
