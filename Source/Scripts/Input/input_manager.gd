class_name InputManager
extends Node

# we are going to use this enum to keep track of the current user controller type
# if it's keyboard and mouse, or gamepad
enum InputType { KEYBOARD_MOUSE, GAMEPAD, NOT_SET }

@export_group("Events")
@export var _on_input_changed_event : BaseEvent
@export var _on_menu_opened_event : BaseEvent

@export_group("Processors")
## different input processors according to player controller
@export var _keyboard_mouse_processor: KeyboardAndMouseProcessor
@export var _game_pad_processor: GamePadProcessor

## According to last controller that the user pressed, we are going to use the correct input
var _last_input : InputType = InputType.NOT_SET
## this is the actual input processor
var _current_input_processor : InputInterface


func _ready() -> void:
	# by default we use keyboard and mouse
	_change_input_type(InputType.KEYBOARD_MOUSE)
	# we subscribe to gamepad changed signal to update input type
	Input.joy_connection_changed.connect(_on_joy_connection_changed)


# here we check if the gamepad was connected or disconnected and we
# update the input type accordingly
func _on_joy_connection_changed(_device_id, connected):
	if connected:
		_change_input_type(InputType.GAMEPAD)
	else:
		_change_input_type(InputType.KEYBOARD_MOUSE)


## TODO: this is only a fast way to quit the game
## we should implement a better way to quit the game using a UI
func _unhandled_input(_event):
	# if the player wants to open the menu
	if _current_input_processor.is_open_menu_pressed():
		# we trigger the event
		_on_menu_opened_event.emit()
		## TODO: this is only temporal, we need to open a UI menu
		get_tree().quit()


# we get the input of the player to see what controller is the player using
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


func _change_input_type(new_input_type: InputType) -> void:
	# if we have the same input type, we don't do anything
	if _last_input == new_input_type:
		return
	# if we have a valid input set, we call the exit method
	if _current_input_processor:
		_current_input_processor.exit_input_type()
	# we update the current input type
	_last_input = new_input_type
	if _last_input == InputType.KEYBOARD_MOUSE:
		_current_input_processor = _keyboard_mouse_processor
	elif _last_input == InputType.GAMEPAD:
		_current_input_processor = _game_pad_processor
	else: # defaults to keyboard
		_current_input_processor = _keyboard_mouse_processor
	# we call the method for start using this input type
	_current_input_processor.enter_input_type()
	# we trigger the signal that the type changed
	_on_input_changed_event.emit()


func get_input_movement() -> Vector2:
	return _current_input_processor.get_input_movement()


func get_look_at() -> Vector2:
	return _current_input_processor.get_look_at()


func is_shot_pressed() -> bool:
	return _current_input_processor.is_shot_pressed()


func is_shot_just_pressed() -> bool:
	return _current_input_processor.is_shot_just_pressed()


func is_shot_just_released() -> bool:
	return _current_input_processor.is_shot_just_released()
