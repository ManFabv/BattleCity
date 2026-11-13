class_name SceneManager
extends Node
## the only node that adds or removes the active scene; it also owns the pause, which belongs to the game

## the pause action, as StringName so the event doesn't convert a String on every check
const _OPEN_UI_MENU_ACTION : StringName = &"open_ui_menu"

@export_group("Scenes")
## the levels in play order; level 0 is the first one
@export var _level_scenes : Array[PackedScene]
## the screen shown at startup and when the player goes back to the menu
@export var _main_menu_scene : PackedScene
## the screen shown after winning the last level
@export var _victory_scene : PackedScene
## the screen shown after losing a level
@export var _defeat_scene : PackedScene
## the screen with the volume sliders
@export var _options_scene : PackedScene

@export_group("References")
## the cover shown while a scene is swapped; a child of this scene, so it survives every swap
@export var _loading_screen : LoadingScreen
## the pause menu shown over a paused level; a child of this scene, so it survives every swap
@export var _pause_overlay : PauseOverlay
## the game progress: told which level is played, read to continue; the GameResultController saves it
@export var _game_progress : GameProgressResource

@export_group("Events")
## event emitted once a level is won, we load the next level or the victory screen
@export var _on_victory : BaseEvent
## event emitted once a level is lost, we show the defeat screen
@export var _on_defeat : BaseEvent
## event emitted by the play buttons, we start a new game at the first level
@export var _on_play_pressed : BaseEvent
## event emitted by the continue button, we start the saved game level
@export var _on_continue_pressed : BaseEvent
## event emitted by the options button, we show the options screen
@export var _on_options_pressed : BaseEvent
## event emitted by the restart buttons (pause menu, defeat screen), we start the current level again
@export var _on_restart_pressed : BaseEvent
## event emitted by the resume button of the pause menu, we resume the level
@export var _on_resume_pressed : BaseEvent
## event emitted by the menu buttons, we show the main menu
@export var _on_menu_pressed : BaseEvent
## event emitted by the quit button, we close the game
@export var _on_quit_pressed : BaseEvent

## the scene currently shown, null until the first swap
var _current_scene : Node
## true while the scene shown is a level, the only kind of scene that can be paused
var _is_level_shown : bool = false
## true while a scene change runs; a second request is ignored until it ends
var _is_changing_scene : bool = false

## index of the level being played
var _current_level_index : int = 0:
	set(new_value):
		# we clamp the index to the configured levels
		_current_level_index = clampi(new_value, 0, maxi(_level_scenes.size() - 1, 0))


## we listen to the outcomes and the buttons and show the main menu; the global systems above us are already subscribed
func _ready() -> void:
	_on_victory.subscribe(_on_victory_handler, tree_exited)
	_on_defeat.subscribe(_on_defeat_handler, tree_exited)
	_on_play_pressed.subscribe(_on_play_pressed_handler, tree_exited)
	_on_continue_pressed.subscribe(_on_continue_pressed_handler, tree_exited)
	_on_options_pressed.subscribe(_on_options_pressed_handler, tree_exited)
	_on_restart_pressed.subscribe(_on_restart_pressed_handler, tree_exited)
	_on_resume_pressed.subscribe(_on_resume_pressed_handler, tree_exited)
	_on_menu_pressed.subscribe(_on_menu_pressed_handler, tree_exited)
	_on_quit_pressed.subscribe(_on_quit_pressed_handler, tree_exited)
	# the game starts at the main menu
	_show_scene(_main_menu_scene, false)


## runs while paused (process_mode Always), so the same input pauses and resumes the level
## unhandled: the GUI, such as a screen's buttons, gets the event before us
func _unhandled_input(event: InputEvent) -> void:
	# only a level can be paused, never mid-change, and only on a fresh press of this event, never an echo or another event of the frame
	if _is_level_shown and not _is_changing_scene and event.is_action_pressed(_OPEN_UI_MENU_ACTION, false):
		# we consume the event so no other node handles it
		get_viewport().set_input_as_handled()
		# the same input opens and closes the pause menu
		_set_level_paused(not get_tree().paused)


## pauses or resumes the level and opens or closes the pause menu with it
func _set_level_paused(is_paused: bool) -> void:
	# the tree pause stops every pausable node (movement, AI, timers); the menu is Always, so it keeps working
	get_tree().paused = is_paused
	if is_paused:
		_pause_overlay.open()
	else:
		_pause_overlay.close()


## shows the level of the given index
func _show_level(level_index: int) -> void:
	# without levels there is nothing to show, we report it instead of leaving an empty screen
	if _level_scenes.is_empty():
		push_error("SceneManager has no level scenes")
		return
	# we keep the index of the level we are going to play
	_current_level_index = level_index
	# the progress knows which level is played, so a win saves the next one
	_game_progress.begin_game_level(_current_level_index)
	_show_scene(_level_scenes[_current_level_index], true)


## shows the given scene, reporting an empty slot before changing anything
func _show_scene(new_scene: PackedScene, is_level: bool) -> void:
	# an empty slot would leave a screen where nothing responds
	if is_instance_valid(new_scene):
		# deferred: an outcome can arrive inside a physics callback, where bodies can't leave the tree nor the tree pause
		_change_scene.call_deferred(new_scene, is_level)
	else:
		push_error("SceneManager has an empty scene slot (level index %d, is level: %s)" % [_current_level_index, is_level])


## covers the screen, swaps the scene and uncovers it once the new scene is loaded; nothing moves meanwhile
## TODO: lowest priority, load the scene with ResourceLoader.load_threaded_request() while covered (the web build has no threads)
func _change_scene(new_scene: PackedScene, is_level: bool) -> void:
	# a request during a change (ex: a click on the fading screen) is dropped
	if _is_changing_scene:
		return
	_is_changing_scene = true
	# a change can start from the pause menu (restart, menu): the fade covers the scene, not the menu
	_pause_overlay.close()
	# the old scene freezes under the fade and the new one doesn't start until it is uncovered
	get_tree().paused = true
	await _loading_screen.show_loading()
	_swap_scene(new_scene, is_level)
	# one frame so the new scene finishes its _ready() and draws once before it is uncovered
	await get_tree().process_frame
	await _loading_screen.hide_loading()
	get_tree().paused = false
	_is_changing_scene = false


## replaces the active scene with a new instance of the given one
func _swap_scene(new_scene: PackedScene, is_level: bool) -> void:
	if is_instance_valid(_current_scene):
		# remove_child() runs its tree_exited now, so its events and timers are released before the new _ready()
		remove_child(_current_scene)
		# the node is freed at the end of the frame
		_current_scene.queue_free()
	# we only need a Node to parent it
	_current_scene = new_scene.instantiate()
	# we are Always and our children would inherit it, so the pause wouldn't freeze the scene
	_current_scene.process_mode = Node.PROCESS_MODE_PAUSABLE
	_is_level_shown = is_level
	add_child(_current_scene)


## the level was won (the progress was already saved): the next level, or the victory screen after the last one
func _on_victory_handler(_event_context: Variant = null) -> void:
	if _current_level_index < _level_scenes.size() - 1:
		_show_level(_current_level_index + 1)
	else:
		# the game is finished, there is nothing left to continue
		_game_progress.clear_progress()
		_show_scene(_victory_scene, false)


## the level was lost: we show the defeat screen
func _on_defeat_handler(_event_context: Variant = null) -> void:
	_show_scene(_defeat_scene, false)


## the player starts a new game: the previous save is deleted and it starts at the first level with the first tank level
func _on_play_pressed_handler(_event_context: Variant = null) -> void:
	_game_progress.clear_progress()
	_show_level(0)


## the player continues the saved game level, with the saved tank level
func _on_continue_pressed_handler(_event_context: Variant = null) -> void:
	_show_level(_game_progress.get_game_level_index())


## the player opens the options
func _on_options_pressed_handler(_event_context: Variant = null) -> void:
	_show_scene(_options_scene, false)


## the current level starts over (pause menu, defeat screen), with the saved tank level (0 after a defeat)
func _on_restart_pressed_handler(_event_context: Variant = null) -> void:
	_show_level(_current_level_index)


## the player resumes the paused level
func _on_resume_pressed_handler(_event_context: Variant = null) -> void:
	_set_level_paused(false)


## the player goes back to the main menu
func _on_menu_pressed_handler(_event_context: Variant = null) -> void:
	_show_scene(_main_menu_scene, false)


## the player closes the game (main menu or pause menu); the button is hidden in the web build, where quitting does nothing
func _on_quit_pressed_handler(_event_context: Variant = null) -> void:
	get_tree().quit()
