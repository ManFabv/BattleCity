extends Node3D

@export var _input_manager: PackedScene
@export var _player: PackedScene
@export var _player_camera: PackedScene
@export var _world: PackedScene


func _ready() -> void:
	# we instantiate the scenes for world
	var current_world : Node3D = _world.instantiate() as Node3D
	# we add the nodes to the tree and then _ready is called in order
	add_child(current_world)
	# we instantiate the scenes for camera
	var current_player_camera : PlayerCamera = _player_camera.instantiate() as PlayerCamera
	# we add the nodes to the tree and then _ready is called in order
	add_child(current_player_camera)
	# we set camera position
	current_player_camera.global_position = Vector3(0, 10, 6.5)
	# we set camera rotation
	current_player_camera.global_rotation_degrees = Vector3(-70, 0, 0)
	# we instantiate input manager
	var current_input_manager : InputManager = _input_manager.instantiate() as InputManager
	# we add node to the tree and then _ready is called in order
	add_child(current_input_manager)
	# we instantiate the player
	var current_player : Player = _player.instantiate() as Player
	# we inject the player and player camera
	current_input_manager.setup_before_enter_tree(current_player_camera, current_player)
	# we inject the input manager to the player class
	current_player.input_manager = current_input_manager
	# we add node to the tree and then _ready is called in order
	add_child(current_player)
