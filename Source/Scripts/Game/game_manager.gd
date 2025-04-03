extends Node3D

@export var _input_manager: PackedScene
@export var _player: PackedScene
@export var _enemy: PackedScene
@export var _player_camera: PackedScene
@export var _world: PackedScene
@export var _player_controller: PackedScene
@export var _enemy_controller: PackedScene


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
	var current_player : ControllableEntity = _player.instantiate() as ControllableEntity
	# we inject the player and player camera and event bus
	current_input_manager.configure(current_player_camera, current_player)
	# we instantiate the player controller
	var current_player_controller : PlayerController = _player_controller.instantiate() as PlayerController
	# we inject the player and player camera and event bus
	current_player_controller.configure(current_input_manager, current_player)
	# we add node to the tree and then _ready is called in order
	add_child(current_player_controller)
	# we inject the event bus and player controller to the player class
	current_player.configure(current_player_controller)
	# we add node to the tree and then _ready is called in order
	add_child(current_player)
	# we instantiate the enemy controlled by AI
	var current_enemy_controller : AIController = _enemy_controller.instantiate() as AIController
	# we add node to the tree and then _ready is called in order
	add_child(current_enemy_controller)
	# we instantiate the enemy
	var current_enemy : ControllableEntity = _enemy.instantiate() as ControllableEntity
	# we inject the event bus and enemy controller to the enemy class
	current_enemy.configure(current_enemy_controller)
	# we move it up on the Z axis and right to the X axis
	current_enemy.position += Vector3(5, 0, -5)
	# we add node to the tree and then _ready is called in order
	add_child(current_enemy)
