class_name InputManager
extends Node

# we are going to use this enum to keep track of the current user controller type
# if it's keyboard and mouse, or gamepad
enum InputType { KEYBOARD_MOUSE, GAMEPAD, DUMMY, NOT_SET }

## different input processors according to player controller
@onready var _keyboard_mouse_processor: Node = $InputInterface/KeyboardMouseProcessor
@onready var _game_pad_processor: Node = $InputInterface/GamePadProcessor

## According to last controller that the user pressed, we are going to use the correct input
var _last_input : InputType = InputType.DUMMY
## this is the actual input processor
var _current_input_processor : InputInterface
## this is the reference to event bus
var event_bus : EventBus


func configure(new_player_camera: PlayerCamera, 
		new_player: Player, new_event_bus: EventBus) -> void:
	#we cache the event bus
	event_bus = new_event_bus
	#we initialize processors
	_keyboard_mouse_processor.configure(new_player_camera, new_player)
	_game_pad_processor.configure(new_player_camera, new_player)
	# by default we use keyboard and mouse
	_change_input_type(InputType.KEYBOARD_MOUSE)


func _ready() -> void:
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
		event_bus.emit(BaseEvent.EventId.ON_MENU_OPENED)
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
	# we update the current input type
	_last_input = new_input_type
	if _last_input == InputType.KEYBOARD_MOUSE:
		_current_input_processor = _keyboard_mouse_processor
	elif _last_input == InputType.GAMEPAD:
		_current_input_processor = _game_pad_processor
	else: # defaults to keyboard
		_current_input_processor = _keyboard_mouse_processor
	# we trigger the signal that the type changed
	event_bus.emit(BaseEvent.EventId.INPUT_TYPE_CHANGED)


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
