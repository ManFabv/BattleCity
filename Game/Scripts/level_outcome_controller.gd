class_name LevelOutcomeController
extends Node

## the base that must survive for the level to continue
@export var _base : Base
## event emitted once the level is lost
@export var _on_defeat : BaseEvent


func _ready() -> void:
	_base.base_destroyed.connect(_on_base_destroyed)
	# TODO: wire player defeat once the lives/respawn system exists (see GitHub issue)


## the base ran out of health, so the level is lost
func _on_base_destroyed() -> void:
	_on_defeat.emit()
