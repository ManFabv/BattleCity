class_name MainMenuScreen
extends Control
## main menu: it only offers to continue when there is a saved game

@export_group("References")
## the saved progress, read by the GameManager before this screen exists
@export var _game_progress : GameProgressResource
## the button that continues the saved game
@export var _continue_button : Button
## the button focused when there is nothing to continue
@export var _play_button : Button


## without a saved game the continue button is hidden and the play button takes the focus
func _ready() -> void:
	if _game_progress.has_saved_game():
		_continue_button.grab_focus()
	else:
		_continue_button.hide()
		_play_button.grab_focus()
