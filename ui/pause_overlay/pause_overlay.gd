class_name PauseOverlay
extends CanvasLayer
## pause menu the SceneManager shows over a paused level; Always, so its buttons work while the tree is paused

@export_group("References")
## the button focused when the menu opens, so a keyboard or a gamepad can navigate it without a mouse
@export var _first_focused_button : Button


## we start closed, so nothing blocks the input
func _ready() -> void:
	hide()


## shows the menu and focuses its first button
func open() -> void:
	show()
	# the ui_* actions navigate from the focused control: without focus the gamepad can't use the menu
	_first_focused_button.grab_focus()


## hides the menu
func close() -> void:
	hide()
