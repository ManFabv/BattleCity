class_name GrenadePowerUp
extends Area3D

## container holding every currently spawned enemy, wired manually in the level
@export var _enemy_container : NodeContainer


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: ControllableEntity) -> void:
	# duplicate() because eliminate() below removes each enemy from this same array
	for enemy: ControllableEntity in _enemy_container.get_children().duplicate():
		enemy.eliminate()
	queue_free()
