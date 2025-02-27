class_name StateMachine
extends Node

@export var current_state: EntityState


# we process the current state and check if we need to change to a new one
func _process(delta) -> void:
	current_state.update(delta)
	if current_state.can_transition():
		var new_state : EntityState = current_state.get_new_state_to_transition()
		change_state(new_state)


# we made the physics process of the current state
func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


# here we call the corresponding methods to change the current 
# state to the new one
func change_state(new_state: EntityState) -> void:
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()
