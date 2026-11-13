class_name OptionsScreen
extends Control
## options screen: its sliders change the volumes live and the screen saves them when it leaves the tree

@export_group("References")
## the shared settings the sliders change
@export var _audio_settings : AudioSettingsResource
## the control focused when the screen appears, so a keyboard or a gamepad can use it without a mouse
@export var _first_focused_control : Control


## the ui_* actions navigate from the focused control: without focus the gamepad can't use the screen
func _ready() -> void:
	_first_focused_control.grab_focus()


## however the screen is left, the volumes are written once instead of on every slider step
func _exit_tree() -> void:
	_audio_settings.save_settings()
