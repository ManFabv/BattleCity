class_name LoadingScreen
extends CanvasLayer
## full screen cover the SceneManager shows while it swaps scenes: it fades to black with the loading text and fades back

@export_group("References")
## the full screen control that holds the black background and the loading text; its alpha is the fade
@export var _cover : Control

@export_group("Config")
## seconds each fade takes, to black and back
@export_range(0.0, 2.0) var _fade_duration_seconds : float = 0.3:
	set(new_value):
		# a negative duration means no fade
		_fade_duration_seconds = maxf(new_value, 0.0)


## we start uncovered and hidden, so nothing blocks the input
func _ready() -> void:
	_cover.modulate.a = 0.0
	hide()


## shows the cover and fades it in; awaitable, it returns once the screen is fully covered
func show_loading() -> void:
	show()
	await _fade_cover(1.0)


## fades the cover out and hides it; awaitable, it returns once the screen is uncovered
func hide_loading() -> void:
	await _fade_cover(0.0)
	hide()


## animates the cover alpha to the given value and waits for it
func _fade_cover(target_alpha: float) -> void:
	var tween : Tween = create_tween()
	# the SceneManager pauses the tree during the swap, the fade must keep running
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(_cover, "modulate:a", target_alpha, _fade_duration_seconds)
	await tween.finished
