class_name LevelStartPrompt
extends CanvasLayer
## text shown when a level starts; the level waits until it ends, so nothing moves while the player reads it

## emitted once the prompt was shown for its whole duration
signal _finished

@export_group("References")
## the shared timer manager the prompt duration is requested from
@export var _timer_manager : TimerManagerResource

@export_group("Config")
## seconds the prompt stays on screen before the level starts
@export_range(0.1, 5.0) var _duration_seconds : float = 1.0:
	set(new_value):
		# a negative duration means no wait
		_duration_seconds = maxf(new_value, 0.0)


## we stay hidden until the level shows the prompt
func _ready() -> void:
	hide()


## shows the text and starts counting; the timer only ticks while the tree runs, so a scene transition doesn't eat it
func show_prompt() -> void:
	show()
	_timer_manager.create_one_shot(_duration_seconds, _on_duration_timer_timeout, tree_exited)


## listeners are notified once the prompt ends
func subscribe_to_finished(on_finished: Callable) -> void:
	_finished.connect(on_finished)


## the prompt was shown long enough: we hide it and let the level start
func _on_duration_timer_timeout() -> void:
	hide()
	_emit_finished_signal()


## notifies that the prompt ended
func _emit_finished_signal() -> void:
	_finished.emit()
