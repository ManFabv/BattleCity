extends CharacterBody3D

@export_group("Movement")
@export_range(1, 10) var move_speed : float = 5
@export_range(1, 10) var move_damping : float = 8
@export_range(1, 10) var gravity_modifier : float = 10
@export_group("Player")
@export_range(1, 2) var player_id : int = 1

#we are applying the gravity defined by the setting and the multiplier set by the inspector
@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_modifier

#input action names variables
var move_left_name : String
var move_right_name : String
var move_up_name : String
var move_down_name : String
var fire_prymary_name : String

#calculated velocity by input
var move_velocity : Vector3 = Vector3.ZERO

func _ready() -> void:
	# we map the input actions according to this player id
	move_left_name = "move_left_p" + str(player_id)
	move_right_name = "move_right_p" + str(player_id)
	move_up_name = "move_up_p" + str(player_id)
	move_down_name = "move_down_p" + str(player_id)
	fire_prymary_name = "fire_primary_p" + str(player_id)


func _process(delta) -> void:
	# this can be processed on another class by AI
	var move_input = _process_input()
	var applied_gravity = _process_gravity()
	
	# we convert 2D input to 3D movement
	var move_direction = Vector3(move_input.x, 0, move_input.y)
	# we calculate a desired velocity
	var target_velocity = move_direction * move_speed
	# we are incrementing the velocity to make it match the desired velocity
	move_velocity.x = lerp(velocity.x, target_velocity.x, move_damping * delta)
	move_velocity.y = applied_gravity * delta
	move_velocity.z = lerp(velocity.z, target_velocity.z, move_damping * delta)
	

func _physics_process(delta) -> void:
	# we update the velocity according to the input given on process function
	velocity = move_velocity
	# we move the object with that velocity
	move_and_slide()


func _process_input() -> Vector2:
	# instead of using get vector, we get the inputs one by one to
	# give the feeling as the retro controls of the game and this
	# way we avoid moving upper left or other combinations like that
	# var move_input = Input.get_vector(move_left_name, move_right_name, move_up_name, move_down_name)
	var move_input = Vector2.ZERO
	
	# we exclude multiple inputs
	if Input.is_action_pressed(move_left_name):
		move_input.x = -1
	elif Input.is_action_pressed(move_right_name):
		move_input.x = 1
	elif Input.is_action_pressed(move_up_name):
		move_input.y = -1
	elif Input.is_action_pressed(move_down_name):
		move_input.y = 1
		
	return move_input

func _process_gravity() -> float:
	var applied_gravity = 0.0
	# if we are falling, we make a sum of the velocity on Y and applying gravity
	if not is_on_floor():
		applied_gravity = move_velocity.y - gravity
	return applied_gravity
