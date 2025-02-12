class_name EventBus
extends Node

#dictionary to hold all the events
var _events: Dictionary = {}


#if the event with that id is not created, we create a new one
#and if it's already available, we return it
func _get_or_create_event(event_id: BaseEvent.EventId) -> BaseEvent:
	if not _events.has(event_id):
		_events[event_id] = BaseEvent.create()
	return _events[event_id]


#we subscribe to this event (and we create a new one if not any)
func subscribe(event_id: BaseEvent.EventId, method: Callable) -> void:
	var event = _get_or_create_event(event_id)
	event.subscribe(method)


#if the event exists, we unsubscribe this method
func unsubscribe(event_id: BaseEvent.EventId, method: Callable) -> void:
	if _events.has(event_id):
		_events[event_id].unsubscribe(method)


#we emmit the signal with that id
func emit(event_id: BaseEvent.EventId) -> void:
	var event = _get_or_create_event(event_id)
	event.emit()
