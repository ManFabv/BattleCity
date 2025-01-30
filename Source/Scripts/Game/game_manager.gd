extends Node3D

@onready var input_manager: InputManager = $InputManager
@onready var player: Player = $Player


func _ready() -> void:
	# we inject the input manager to the player class
	player.input_manager = input_manager
