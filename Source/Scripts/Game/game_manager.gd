extends Node3D

@onready var input_manager: InputManager = $InputManager
@onready var player: Player = $Player
@onready var player_camera: Camera3D = $PlayerCamera


func _ready() -> void:
	# we inject the player and player camera
	input_manager.setup_before_enter_tree(player_camera, player)
	# we inject the input manager to the player class
	player.input_manager = input_manager
