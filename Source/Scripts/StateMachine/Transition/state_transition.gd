class_name StateTransition
extends Node

## the state where we want to transition when the condition is met
@export var next_state: EntityState
## the condition to evaluate to see if we can transition to another state
@export var condition: StateTransitionCondition


# here we evaluate if a condition is met
func can_transition() -> bool:
	return condition.is_met()
