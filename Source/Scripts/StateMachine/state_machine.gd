class_name StateMachine
extends Node

@export var _initial_state: EntityState
@export var _owner_controllable_entity: ControllableEntity

# state that is currently running
var _current_state: EntityState


## we start the state machine with the initial state
func _ready() -> void:
	change_state(_initial_state)


# here we call the corresponding methods to change the current 
# state to the new one
func change_state(new_state: EntityState) -> void:
	_exit_current_state()
	_current_state = new_state
	_enter_current_state()


## we exit the current state and disconnect the signal to avoid memory leaks
func _exit_current_state() -> void:
	if _current_state != null:
		_current_state.transition_requested.disconnect(_on_transition_requested)
		_current_state.exit()


## we enter the new state and connect the signal to be notified when we want to change to another state
func _enter_current_state() -> void:
	if _current_state != null:
		_current_state.enter(_owner_controllable_entity)
		_current_state.transition_requested.connect(_on_transition_requested)


func _on_transition_requested(new_state: EntityState) -> void:
	change_state(new_state)
