class_name BaseEvent
extends Resource

# this is the sinal where we are going to connect
# the methods to be triggered
signal _event_signal(event_context: Variant)


# we emit the signal
func emit(event_context: Variant = null) -> void:
	_event_signal.emit(event_context)


# we connect the method from the signal
func subscribe(method: Callable, on_unsubscribe_requested: Signal) -> void:
	if not _is_event_connected(method):
		_event_signal.connect(method)
		# we grab the current method using bind so the unsubscribe knows
		# which method should disconnect
		on_unsubscribe_requested.connect(unsubscribe.bind(method))


# we disconnect the method from the signal
func unsubscribe(method: Callable) -> void:
	if _is_event_connected(method):
		_event_signal.disconnect(method)


func _is_event_connected(method: Callable) -> bool:
	return _event_signal.is_connected(method)
