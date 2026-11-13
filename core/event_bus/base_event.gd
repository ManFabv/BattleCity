class_name BaseEvent
extends Resource

## this is the signal where we are going to connect the methods to be triggered
signal _event_signal(event_context: Variant)


## we emit the signal
func emit(event_context: Variant = null) -> void:
	_event_signal.emit(event_context)


## we connect the method until on_unsubscribe_requested is emitted
func subscribe(method: Callable, on_unsubscribe_requested: Signal) -> void:
	# a method connected twice would run twice per emit
	if not _is_event_connected(method):
		_event_signal.connect(method)
		# the bound method tells unsubscribe which connection to remove
		on_unsubscribe_requested.connect(unsubscribe.bind(method), CONNECT_ONE_SHOT)


## we disconnect the method from the signal
func unsubscribe(method: Callable) -> void:
	if _is_event_connected(method):
		_event_signal.disconnect(method)


## we check if the signal is actually connected
func _is_event_connected(method: Callable) -> bool:
	return _event_signal.is_connected(method)
