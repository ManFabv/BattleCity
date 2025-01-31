extends Node3D

@onready var input_manager: InputManager = $InputManager
@onready var player: Player = $Player
@onready var player_camera: Camera3D = $PlayerCamera


func _ready() -> void:
	# we inject the player camera
	input_manager.player_camera = player_camera
	# we inject the input manager to the player class
	player.input_manager = input_manager
