class_name EventButton
extends Button
## a button that announces its press through an event; it never knows which scene comes next

@export_group("Events")
## event emitted when this button is pressed
@export var _on_pressed : BaseEvent

@export_group("Config")
## hides the button in the web build, where its action does nothing (ex: quitting the game)
@export var _is_hidden_on_web : bool = false
## focuses this button when its screen appears, so a keyboard or a gamepad can navigate the screen without a mouse
@export var _grabs_focus_on_ready : bool = false


## we hide the button where it can't work, take the initial focus if asked and announce every press
func _ready() -> void:
	# the browser owns the page, so get_tree().quit() does nothing there
	if _is_hidden_on_web and OS.has_feature("web"):
		hide()
	# the ui_* actions navigate from the focused control: without focus the gamepad can't use the screen
	if _grabs_focus_on_ready:
		grab_focus()
	pressed.connect(_emit_pressed_event)


## announces the press, the listeners decide what it means
func _emit_pressed_event() -> void:
	_on_pressed.emit()
