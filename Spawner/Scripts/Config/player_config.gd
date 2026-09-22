class_name PlayerConfig
extends Resource

## the player scene to instantiate, one instance per life
@export var player_scene : PackedScene
## how many lives the player starts with
@export var starting_lives : int = 3
## entity level (stats/health/weapon) the player starts at on their first life
## of the run; every life after a death always restarts this at level 0,
## regardless of this value
@export var initial_entity_level : int = 0
## which game level/stage the player starts the run on. Unlike initial_entity_level,
## this is NOT reset by losing a life -- only a full run restart resets it.
## NOTE: no stage/level-progression system exists yet; this field only holds the
## starting value for whenever that system is built (separate ticket). Nothing
## reads or advances it today.
@export var initial_game_level : int = 0
