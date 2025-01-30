class_name InputManager
extends Node

# signal that we are going to trigger when the control type changes
signal input_type_changed()

# we are going to use this enum to keep track of the current user controller type
# if it's keyboard and mouse, or gamepad
enum InputType { KEYBOARD_MOUSE, GAMEPAD, DUMMY, NOT_SET }

@export_group("Input")
## According to last controller that the user pressed, we are going to use the input actions corresponding to that controller, e.g. gamepad is not same as mouse
@export var last_input : InputType = InputType.DUMMY
## this is the actual input processor
@export var current_input_processor : InputInterface

## different input processors according to player controller
@onready var keyboard_mouse_processor: Node = $InputInterface/KeyboardMouseProcessor
@onready var game_pad_processor: Node = $InputInterface/GamePadProcessor


func _ready() -> void:
	change_input_type(InputType.KEYBOARD_MOUSE)


# we get the input of the player to see what controller is the player using
func _input(event: InputEvent) -> void:
	# if it's mouse or keyboard used
	if event is InputEventMouseMotion or event is InputEventMouseButton or event is InputEventKey:
		change_input_type(InputType.KEYBOARD_MOUSE)
	# if it's gamepad
	elif event is InputEventJoypadMotion or event is InputEventJoypadButton:
		change_input_type(InputType.GAMEPAD)
	# defaults to keyboard
	else:
		change_input_type(InputType.KEYBOARD_MOUSE)


func change_input_type(new_input_type: InputType) -> void:
	# if we have the same input type, we don't do anything
	if last_input == new_input_type:
		return
	
	# we update the current input type
	last_input = new_input_type
	
	if last_input == InputType.KEYBOARD_MOUSE:
		current_input_processor = keyboard_mouse_processor
	elif last_input == InputType.GAMEPAD:
		current_input_processor = game_pad_processor
	else: # defaults to keyboard
		current_input_processor = keyboard_mouse_processor
	# we trigger the signal that the type changed
	input_type_changed.emit()


func get_input() -> Vector2:
	return current_input_processor.get_input()
