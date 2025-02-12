class_name BaseEvent
extends Node

# here we are going to define event types to trigger
enum EventId {
	# signal that we are going to trigger when the control type changes
	INPUT_TYPE_CHANGED,
	# signal that we are going to trigger when the player opens the menu
	ON_MENU_OPENED 
}

# this is the sinal where we are going to connect
# the methods to be triggered
signal _event_signal


# we emit the signal
func emit() -> void:
	_event_signal.emit()


# we connect the method from the signal
func subscribe(method: Callable) -> void:
	_event_signal.connect(method)


# we disconnect the method from the signal
func unsubscribe(method: Callable) -> void:
	_event_signal.disconnect(method)


# factory method to create a new event
static func create() -> BaseEvent:
	return BaseEvent.new()
