class_name LevelPrompt
extends CanvasLayer
## text shown over the level for a while (ex: "¡Listo!" at the start, the result at the end); whoever shows it waits for _finished

## emitted once the prompt was shown for its whole duration
signal _finished

@export_group("References")
## the shared timer manager the prompt duration is requested from
@export var _timer_manager : TimerManagerResource
## the label that shows the prompt text
@export var _prompt_label : Label

@export_group("Config")
## text shown on screen (ex: each level overrides its start prompt with its number, "NIVEL 2" and "¡Listo!" on two lines)
@export_multiline var _prompt_text : String = "¡Listo!"
## seconds the prompt stays on screen before it finishes
@export_range(0.1, 5.0) var _duration_seconds : float = 1.0:
	set(new_value):
		# a negative duration means no wait
		_duration_seconds = maxf(new_value, 0.0)


## we take the configured text and stay hidden until someone shows the prompt
func _ready() -> void:
	_prompt_label.text = _prompt_text
	hide()


## shows the text and starts counting; the timer only ticks while the tree runs, so a scene transition doesn't eat it
func show_prompt() -> void:
	show()
	_timer_manager.create_one_shot(_duration_seconds, _on_duration_timer_timeout, tree_exited)


## listeners are notified once the prompt ends
func subscribe_to_finished(on_finished: Callable) -> void:
	_finished.connect(on_finished)


## the prompt was shown long enough: we hide it and let whoever waits go on
func _on_duration_timer_timeout() -> void:
	hide()
	_emit_finished_signal()


## notifies that the prompt ended
func _emit_finished_signal() -> void:
	_finished.emit()
