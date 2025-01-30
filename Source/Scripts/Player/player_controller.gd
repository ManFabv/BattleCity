class_name Player
extends CharacterBody3D

@export_group("Movement")
## how fast the body will move
@export_range(1, 10) var move_speed : float = 5
## how fast the body start stopping movement
@export_range(1, 10) var move_damping : float = 8
## how much will modify the player settings gravity
@export_range(1, 10) var gravity_modifier : float = 10

#we are applying the gravity defined by the setting and the multiplier set by the inspector
@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_modifier

#calculated velocity by input
var move_velocity : Vector3 = Vector3.ZERO

#input manager
var input_manager : InputManager:
	set(new_input_manager):
		#we assign the new input manager
		input_manager = new_input_manager
		#we listen to the input type changed signal on input manager
		input_manager.input_type_changed.connect(on_input_type_changed)


func on_input_type_changed() -> void:
	print("INPUT CHANGED")


func _process(delta) -> void:
	# this can be processed on another class by AI
	var move_input = _process_input()
	# we apply gravity to the body
	var applied_gravity = _process_gravity()
	# we convert 2D input to 3D movement
	var move_direction = Vector3(move_input.x, 0, move_input.y).normalized()
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
	return input_manager.get_input()


func _process_gravity() -> float:
	var applied_gravity = 0.0
	# if we are falling, we make a sum of the velocity on Y and applying gravity
	if not is_on_floor():
		applied_gravity = move_velocity.y - gravity
	# we return the correct gravity
	return applied_gravity
