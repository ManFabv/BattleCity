class_name InputManager
extends Node

## the kind of controller the player used last; NOT_SET until the first one is chosen
enum InputType { KEYBOARD_MOUSE, GAMEPAD, NOT_SET }

@export_group("Events")
## event announcing that the active controller type changed
@export var _on_input_type_changed : BaseEvent
## event announcing that the pause input was pressed
@export var _on_pause_input_pressed : BaseEvent

@export_group("Processors")
## processor used while the player plays with keyboard and mouse
@export var _keyboard_mouse_processor : KeyboardAndMouseProcessor
## processor used while the player plays with a gamepad
@export var _game_pad_processor : GamePadProcessor

## the controller type the player used last
var _last_input : InputType = InputType.NOT_SET
## the processor of that controller type
var _current_input_processor : InputInterface


## we start with keyboard and mouse and listen to gamepads being connected
func _ready() -> void:
	# we ignore the gamepad while the game window isn't focused
	Input.ignore_joypad_on_unfocused_application = true
	# by default we use keyboard and mouse
	_change_input_type(InputType.KEYBOARD_MOUSE)
	# we switch the controller type when a gamepad is connected or disconnected
	Input.joy_connection_changed.connect(_on_input_joy_connection_changed)


## runs while paused (process_mode Always) so the pause input can also resume the game
## TODO: show a pause menu with resume and quit instead of only toggling the pause
func _unhandled_input(_event: InputEvent) -> void:
	# if the player pressed the pause input
	if _current_input_processor.is_open_menu_pressed():
		# we announce it so the pause-aware systems react
		_on_pause_input_pressed.emit()


## we get the input of the player to see what controller is the player using
func _input(event: InputEvent) -> void:
	# if it's mouse or keyboard used
	if event is InputEventMouseMotion or event is InputEventMouseButton or event is InputEventKey:
		_change_input_type(InputType.KEYBOARD_MOUSE)
	# if it's gamepad
	elif event is InputEventJoypadMotion or event is InputEventJoypadButton:
		_change_input_type(InputType.GAMEPAD)
	# defaults to keyboard
	else:
		_change_input_type(InputType.KEYBOARD_MOUSE)


## the move axis of the active controller
func get_input_movement() -> Vector2:
	return _current_input_processor.get_input_movement()


## where the active controller aims
func get_look_at() -> Vector2:
	return _current_input_processor.get_look_at()


## true while the shoot input of the active controller is held
func is_shot_pressed() -> bool:
	return _current_input_processor.is_shot_pressed()


## switches to the processor of the given controller type
func _change_input_type(new_input_type: InputType) -> void:
	# if we have the same input type, we don't do anything
	if _last_input == new_input_type:
		return
	# the first change has no previous processor to exit
	if _last_input != InputType.NOT_SET:
		_current_input_processor.exit_input_type()
	# we update the current input type
	_last_input = new_input_type
	# we pick the processor of that type
	match _last_input:
		InputType.GAMEPAD:
			_current_input_processor = _game_pad_processor
		InputType.KEYBOARD_MOUSE:
			_current_input_processor = _keyboard_mouse_processor
	# we call the method for start using this input type
	_current_input_processor.enter_input_type()
	# TODO: the HUD will listen to swap the button icons and the cursor
	_on_input_type_changed.emit()


## a connected gamepad becomes the active controller, a disconnected one gives it back to keyboard and mouse
func _on_input_joy_connection_changed(_device_id: int, connected: bool) -> void:
	if connected:
		_change_input_type(InputType.GAMEPAD)
	else:
		_change_input_type(InputType.KEYBOARD_MOUSE)
