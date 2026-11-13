class_name SceneManager
extends Node
## the only node that adds or removes the active scene; it also owns the pause, which belongs to the game

## the pause action, as StringName so the event doesn't convert a String on every check
const _OPEN_UI_MENU_ACTION : StringName = &"open_ui_menu"

@export_group("Scenes")
## the levels in play order; level 0 is the first one
@export var _level_scenes : Array[PackedScene]

@export_group("Events")
## event emitted once a level is won, we load the next level
@export var _on_victory : BaseEvent
## event emitted once a level is lost, we start again from the first level
@export var _on_defeat : BaseEvent

## the scene currently shown, null until the first swap
var _current_scene : Node

## index of the level being played
var _current_level_index : int = 0:
	set(new_value):
		# we clamp the index to the configured levels
		_current_level_index = clampi(new_value, 0, maxi(_level_scenes.size() - 1, 0))


## we listen to the level outcomes and show the first level; the global systems above us are already subscribed
func _ready() -> void:
	_on_victory.subscribe(_on_victory_handler, tree_exited)
	_on_defeat.subscribe(_on_defeat_handler, tree_exited)
	# the game starts at the first level
	_show_level(0)


## runs while paused (process_mode Always), so the same input pauses and resumes the level
## unhandled: the GUI, such as a future pause overlay, gets the event before us
func _unhandled_input(event: InputEvent) -> void:
	# only a level can be paused, and only on a fresh press of this event, never an echo or another event of the frame
	if _is_level_active() and event.is_action_pressed(_OPEN_UI_MENU_ACTION, false):
		# we consume the event so no other node handles it
		get_viewport().set_input_as_handled()
		# the tree pause stops every pausable node (movement, AI, timers)
		get_tree().paused = not get_tree().paused


## shows the level of the given index, reporting an empty slot before changing anything
func _show_level(level_index: int) -> void:
	# without levels there is nothing to show, we report it instead of leaving an empty screen
	if _level_scenes.is_empty():
		push_error("SceneManager has no level scenes")
		return
	# we keep the index of the level we are going to play
	_current_level_index = level_index
	var level_scene : PackedScene = _level_scenes[_current_level_index]
	# an empty slot would leave a screen where nothing responds
	if is_instance_valid(level_scene):
		# deferred: an outcome can arrive inside a physics callback, where bodies can't leave the tree
		_swap_scene.call_deferred(level_scene)
	else:
		push_error("SceneManager has an empty level slot at index %d" % _current_level_index)


## true while the active scene is a level
func _is_level_active() -> bool:
	return is_instance_valid(_current_scene)


## replaces the active scene with a new instance of the given one
func _swap_scene(new_scene: PackedScene) -> void:
	# a new scene never starts paused
	get_tree().paused = false
	if is_instance_valid(_current_scene):
		# remove_child() runs its tree_exited now, so its events and timers are released before the new _ready()
		remove_child(_current_scene)
		# the node is freed at the end of the frame
		_current_scene.queue_free()
	# we only need a Node to parent it
	_current_scene = new_scene.instantiate()
	# we are Always and our children would inherit it, so the pause wouldn't freeze the scene
	_current_scene.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(_current_scene)


## the level was won: the next level, or the first one again after the last
## TODO: the victory screen will be shown after the last level
func _on_victory_handler(_event_context: Variant = null) -> void:
	# after the last level we go back to the first one
	if _current_level_index < _level_scenes.size() - 1:
		_show_level(_current_level_index + 1)
	else:
		_show_level(0)


## the level was lost: we start again from the first level
## TODO: the defeat screen will be shown instead
func _on_defeat_handler(_event_context: Variant = null) -> void:
	_show_level(0)
