class_name StateMachine
extends Node

@export var _initial_state: EntityState
@export var _owner_controllable_entity: ControllableEntity

# state that is currently running
var _current_state: EntityState


func _ready() -> void:
	_current_state = _initial_state
	_current_state.enter(_owner_controllable_entity)


# we process the current state and check if we need to change to a new one
func _process(delta) -> void:
	_current_state.update(delta)
	_change_if_condition_met()


func _change_if_condition_met() -> void:
	if _current_state.can_transition():
		var new_state : EntityState = _current_state.get_new_state_to_transition()
		change_state(new_state)


# we made the physics process of the current state
func _physics_process(delta: float) -> void:
	_current_state.physics_update(delta)


# here we call the corresponding methods to change the current 
# state to the new one
func change_state(new_state: EntityState) -> void:
	_current_state.exit()
	_current_state = new_state
	_current_state.enter(_owner_controllable_entity)
