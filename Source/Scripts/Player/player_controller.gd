class_name Player
extends CharacterBody3D

@export_group("Movement")
## how fast the body will move
@export_range(1, 10) var _move_speed : float = 5
## how fast the body start stopping movement
@export_range(1, 10) var _move_damping : float = 8
## how much will modify the player settings gravity
@export_range(1, 10) var _gravity_modifier : float = 10
@export_group("Rotation")
## how fast the body will rotate
@export_range(1, 10) var _rotation_speed : float = 7

#we are applying the gravity defined by the setting and the multiplier set by the inspector
@onready var _gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity") * _gravity_modifier

#calculated velocity by input
var _move_velocity : Vector3 = Vector3.ZERO
#desired angle to rotate
var _look_at_angle : float = 0

#input manager
var input_manager : InputManager:
	set(new_input_manager):
		#we assign the new input manager
		input_manager = new_input_manager
		#we listen to the input type changed signal on input manager
		input_manager.input_type_changed.connect(_on_input_type_changed)


func _on_input_type_changed() -> void:
	print("INPUT CHANGED")


func _process(delta) -> void:
	# this can be processed on another class by AI
	var move_input : Vector2 = _process_move_input()
	# we apply gravity to the body
	var applied_gravity : float = _process_gravity()
	# we get the position where we have to look at
	var look_at_input : Vector3 = _process_look_at_input()
	# we convert 2D input to 3D movement
	var move_direction : Vector3 = Vector3(move_input.x, 0, move_input.y).normalized()
	# transform movement direction to be relative to the player's rotation
	move_direction = transform.basis * move_direction
	# we calculate a desired velocity
	var target_velocity : Vector3 = move_direction * _move_speed
	# we are incrementing the velocity to make it match the desired velocity
	_move_velocity.x = lerp(velocity.x, target_velocity.x, _move_damping * delta)
	_move_velocity.y = applied_gravity * delta
	_move_velocity.z = lerp(velocity.z, target_velocity.z, _move_damping * delta)
	# we calculate the angle for the current mouse position (we don't take Y axis cause it's floor level)
	var _desired_look_at_angle = atan2(-look_at_input.x, -look_at_input.z)
	# we calculate the amount of the angle to rotate
	_look_at_angle = lerp_angle(rotation.y, _desired_look_at_angle, _rotation_speed * delta)
	

func _physics_process(delta) -> void:
	# we update the velocity according to the input given on process function
	velocity = _move_velocity
	# we rotate accordingly
	rotation.y = _look_at_angle
	# we move the object with that velocity
	move_and_slide()


func _process_move_input() -> Vector2:
	return input_manager.get_input_movement()


func _process_look_at_input() -> Vector3:
	return input_manager.get_look_at()


func _process_gravity() -> float:
	var applied_gravity : float = 0.0
	# if we are falling, we make a sum of the velocity on Y and applying gravity
	if not is_on_floor():
		applied_gravity = _move_velocity.y - _gravity
	# we return the correct gravity
	return applied_gravity
