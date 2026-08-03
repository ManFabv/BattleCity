class_name FireState
extends EntityState

## an initial time to wait before we start moving to a new position
@export_range(0, 10) var _seconds_between_shots : float = 1

## we cache the controller which will allows us to set callbacks when we reach the target position
var _ai_controller : AIController


# executed at the begin of the new state change
func enter(_owner_controllable_entity : ControllableEntity) -> void:
	# we cache the controller which will allows us to set 
	# shooting status of the entity
	_ai_controller = _owner_controllable_entity._entity_controller as AIController
	# we subscribe to the signal because we want to select another destination
	# after reaching the previous position
	_ai_controller.connect_on_shot_signal(_on_shot)
	# we first wait to avoid crazy shooting of the entity
	await wait(_seconds_between_shots)
	# we then shoot
	_ai_controller.shoot()


## when we shot, we will request a transition to the next state
func _on_shot() -> void:
	request_transition(_next_state)


# executed before changing to the new state change
func exit() -> void:
	_ai_controller.stop_shooting()
	# we unsubscribe to the signal because we want to select another destination
	# after reaching the previous position
	_ai_controller.disconnect_on_shot_signal(_on_shot)


## function that allows us to wait for given seconds
func wait(seconds : float) -> void:
	await get_tree().create_timer(seconds).timeout
