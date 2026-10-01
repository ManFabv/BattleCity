class_name PlayerSpawnPointConfig
extends Resource

@export_group("References")
## the player scene to instantiate, one instance per life
@export var player_scene : PackedScene
@export_group("Config")
## how many lives the player starts with
@export_range(1, 10) var starting_lives : int = 3
## entity level (stats/health/weapon) the player starts at on their first life
## of the run; every life after a death always restarts this at level 0, regardless of this value
@export_range(0, 10) var initial_entity_level : int = 0
