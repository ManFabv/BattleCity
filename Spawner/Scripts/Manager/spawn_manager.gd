class_name SpawnManager
extends Node

@export_group("References")
## spawn points managed by this manager
@export var _spawn_points : Array[SpawnPointInterface]
@export_group("Config")
## creates the strategy that decides what and when to spawn
@export var _strategy_config : SpawnStrategyConfig

## the strategy created from the config, the manager should owns it
var _spawn_strategy : SpawnStrategyInterface


## we create and configure the spawn strategy
func _ready() -> void:
	_spawn_strategy = _strategy_config.create_spawn_strategy()
	_spawn_strategy.configure(_spawn_points, tree_exited)
