class_name KillZone
extends Area3D
## eliminates every controllable entity that falls into it (ex: knocked off the arena)


## we listen to the bodies that enter this zone
func _ready() -> void:
	# we connect the physics signal to the handler below
	body_entered.connect(_on_body_entered)


## eliminates the entity that fell into the zone, the same way a grenade does
func _on_body_entered(controllable_entity: ControllableEntity) -> void:
	# we eliminate it so every listener is notified through the usual death
	controllable_entity.eliminate()
