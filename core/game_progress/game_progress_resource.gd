class_name GameProgressResource
extends Resource
## the progress of the current game: the game level to load and the tank level the player starts it with, kept in user://save.cfg

## the file the progress is saved to, apart from the settings
const _SAVE_PATH : String = "user://save.cfg"
## the section of the save file that holds the progress
const _PROGRESS_SECTION : String = "progress"

## index of the game level being played (which scene the SceneManager loads); the saved one is the level after the last win
var _game_level_index : int = 0:
	set(new_value):
		_game_level_index = maxi(new_value, 0)
## index of the tank level the player starts the current game level with; every life of that level starts with it, a defeat sets it to 0
var _player_entity_level : int = 0:
	set(new_value):
		_player_entity_level = maxi(new_value, 0)
## index of the tank level the player has right now, kept for the next game level when this one is won
var _current_player_entity_level : int = 0:
	set(new_value):
		_current_player_entity_level = maxi(new_value, 0)


## true when there is a game to continue
func has_saved_game() -> bool:
	return FileAccess.file_exists(_SAVE_PATH)


## reads the saved progress, if there is any
func load_progress() -> void:
	var config_file : ConfigFile = ConfigFile.new()
	# without a save file the progress stays at the start of a new game
	if config_file.load(_SAVE_PATH) == OK:
		_game_level_index = config_file.get_value(_PROGRESS_SECTION, "game_level_index", 0)
		_player_entity_level = config_file.get_value(_PROGRESS_SECTION, "player_entity_level", 0)
		_current_player_entity_level = _player_entity_level


## forgets the progress and deletes the save (a new game, or the last level won): there is nothing to continue
func clear_progress() -> void:
	_game_level_index = 0
	_player_entity_level = 0
	_current_player_entity_level = 0
	DirAccess.remove_absolute(_SAVE_PATH)


## the given game level starts (nothing is saved): every life of it starts with the saved tank level
func begin_game_level(game_level_index: int) -> void:
	_game_level_index = game_level_index
	_current_player_entity_level = _player_entity_level


## the level was just won: the next game level and the tank level reached are saved right away
func save_game_level_won() -> void:
	_game_level_index += 1
	_player_entity_level = _current_player_entity_level
	_save_progress()


## the level was just lost: the tank goes back to its first level, saved right away if there is a game to continue
func reset_player_entity_level() -> void:
	_player_entity_level = 0
	_current_player_entity_level = 0
	# losing in a game that never won a level leaves nothing to save
	if has_saved_game():
		_save_progress()


## the game level to continue from
func get_game_level_index() -> int:
	return _game_level_index


## the tank level every life of the current game level starts with
func get_player_entity_level() -> int:
	return _player_entity_level


## the player's tank changed its level (a star, a new life): it is saved if this game level is won
func set_current_player_entity_level(player_entity_level: int) -> void:
	_current_player_entity_level = player_entity_level


## writes the progress to the save file
func _save_progress() -> void:
	var config_file : ConfigFile = ConfigFile.new()
	config_file.set_value(_PROGRESS_SECTION, "game_level_index", _game_level_index)
	config_file.set_value(_PROGRESS_SECTION, "player_entity_level", _player_entity_level)
	config_file.save(_SAVE_PATH)
