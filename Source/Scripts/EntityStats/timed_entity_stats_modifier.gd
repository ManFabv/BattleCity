class_name TimedEntityStatsModifier
extends EntityStatsModifier

## how much time this stats modifier will be applied
@export_range(0, 60) var _duration : float = 3


## Starts the lifetime of this modifier using the SceneTreeTimer
func init(_owner_node: Node) -> void:
	# Safety check to ensure the node is inside the active scene tree
	if not _owner_node.is_inside_tree():
		push_warning("TimedEntityStatsModifier: _owner_node is not inside the SceneTree.")
		return
	setup_timer(_owner_node)
	
func setup_timer(_owner_node: Node) -> void:
	# Create a SceneTreeTimer directly from the tree. 
	# It automatically starts counting down and destroys itself on timeout.
	var _scene_timer : SceneTreeTimer = _owner_node.get_tree().create_timer(_duration)
	# Connect the timeout signal directly to our depletion logic
	_scene_timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	# Trigger the notification that this modifier is depleted
	on_modifier_depleted.emit(self)
