class_name LevelConfig
extends Resource

@export_group("Spawn")
## lives and respawn delay of the player in this level
@export var player_lives_based_spawn_strategy_config : LivesBasedSpawnStrategyConfig
## the base, spawned once at the start of this level
@export var base_once_based_spawn_strategy_config : OnceBasedSpawnStrategyConfig
## the enemy timeline of this level
@export var enemy_timeline_based_spawn_strategy_config : TimelineBasedSpawnStrategyConfig
