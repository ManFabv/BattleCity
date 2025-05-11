class_name StateTransition
extends Node

@warning_ignore_start("unused_private_class_variable")
## the state where we want to transition when the condition is met
@export var _next_state: EntityState
@warning_ignore_restore("unused_private_class_variable")

## the condition to evaluate to see if we can transition to another state
@export var _condition: StateTransitionCondition


# here we evaluate if a condition is met
func can_transition() -> bool:
	return _condition.is_met()
