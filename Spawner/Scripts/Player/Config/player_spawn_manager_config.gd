class_name PlayerSpawnManagerConfig
extends Resource

@export_group("Config")
## how many lives the player starts with
@export_range(1, 10) var starting_lives : int = 3
## how long to wait after death before spawning the next life
@export_range(0.1, 10.0) var respawn_delay : float = 2.0
