extends CharacterBody3D

@export_group("Movement")
@export_range(1, 10) var move_speed : float = 5
@export_range(1, 10) var move_damping : float = 5
@export_range(1, 10) var gravity_modifier : float = 1
@export_group("Player")
@export_range(1, 2) var player_id : int = 1

#we are applying the gravity defined by the setting and the multiplier set by the inspector
@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_modifier

var move_left_name : String
var move_right_name : String
var move_up_name : String
var move_down_name : String
var fire_prymary_name : String

var move_velocity : Vector3 = Vector3.ZERO

func _ready() -> void:
	move_left_name = "move_left_p" + str(player_id)
	move_right_name = "move_right_p" + str(player_id)
	move_up_name = "move_up_p" + str(player_id)
	move_down_name = "move_down_p" + str(player_id)
	fire_prymary_name = "fire_primary_p" + str(player_id)


func _process(delta) -> void:
	var move_input = Input.get_vector(move_left_name, move_right_name, move_up_name, move_down_name)
	var move_direction_normalized = move_input.normalized()
	
	var move_direction = Vector3(move_direction_normalized.x, 0, move_direction_normalized.y)
	var target_velocity = move_direction * move_speed
	
	move_velocity.x = lerp(velocity.x, target_velocity.x, move_damping * delta)
	move_velocity.z = lerp(velocity.z, target_velocity.z, move_damping * delta)


func _physics_process(delta) -> void:
	velocity = move_velocity
	move_and_slide()
