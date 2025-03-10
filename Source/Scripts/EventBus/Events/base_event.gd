class_name BaseEvent
extends Resource

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
