class_name GameManager
extends Node
## root of the boot scene: it loads what the global systems need before any of them is ready

@export_group("References")
## the saved volumes, applied to the buses before anything can play
@export var _audio_settings : AudioSettingsResource
## the saved game progress, read before the main menu decides whether there is a game to continue
@export var _game_progress : GameProgressResource


## _enter_tree() runs on the parent before its children, so every child already sees the saved values
func _enter_tree() -> void:
	_audio_settings.load_settings()
	_game_progress.load_progress()
