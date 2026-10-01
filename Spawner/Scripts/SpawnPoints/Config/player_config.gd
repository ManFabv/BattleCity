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
