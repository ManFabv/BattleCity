class_name AIController
extends EntityController

# TODO: this will implement AI movement for the enemies

func configure(_new_input_manager : InputManager, _new_owner : ControllableEntity) -> void:
	pass


func get_move_direction() -> Vector3:
	return Vector3.ZERO


func get_look_at_angle() -> float:
	return 0


func is_shot_pressed() -> bool:
	return false


func on_input_type_changed() -> void:
	pass


func on_menu_opened() -> void:
	pass
